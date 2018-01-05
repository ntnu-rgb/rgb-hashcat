# 
# Custom fact to retrieve GPU driver
# 
# @return A string with the name of the GPU driver. 
#
# Returns an empty string if no driver is detected or the driver is not recognized. 
# If something else than "NVIDIA", "AMD", "", "nouveau" or "radeon" is returned, an error occured
#
Facter.add(:gpu_driver) do
  osn = Facter.value(:os)['family']
  case osn
  when 'Debian'
                                        # Checks that facter is run as superuser
    if Facter::Core::Execution.exec('id -u') == '0'
                                        # Checks that pciutils is installed, if not - it is installed
      if Facter::Core::Execution.exec('apt-get install pciutils -y > /dev/null; echo $?') == '0'
                                        # Retrieves GPU driver in use
        driver = Facter::Core::Execution.exec('lspci -nnk | grep -i "VGA\|3D\|2D\|DISPLAY" -A3 | grep "in use"')
        if driver.include? 'nvidia'    # If driver is closed source nvidia
          setcode do
            'NVIDIA'
          end
        elsif driver.include? 'nouveau' # If driver is open-source NVIDIA
          setcode do
            'nouveau'
          end
        elsif driver.include? 'amdgpu'  # If driver is closed source AMD
          setcode do
            'AMD'
          end
        elsif driver.include? 'radeon'  # If driver is open source AMD
          setcode do
            'radeon'
          end
        else
          setcode do                    # If driver is something else, output an empty string
            ''
          end
        end
      else
        setcode do                      # Returns an error if apt-get install pciutils returned something else than 0
          'Error while ensuring that pciutils is installed'
        end
      end
    else
      setcode do                        # Returns an error if facter was not run as superuser
        'Error, facter must be run as superuser'
      end
    end
  when 'windows'                        # Runs a powershell script that returns GPU vendor
    driver = Facter::Core::Execution.exec("powershell \"Get-WmiObject Win32_PnPSignedDriver | Where-Object {$_.DeviceID.Contains('VEN_10DE') -or $_.DeviceID.Contains('VEN_1002') -and $_.DeviceClass -eq 'DISPLAY'} | ForEach-Object { Write-Host $_.DriverProviderName }\"")
    if driver.include? 'NVIDIA'
      setcode do
        'NVIDIA'
      end
    elsif driver.include? 'Advanced Micro Devices, Inc.'
      setcode do
        'AMD'
      end
    elsif driver.include? 'AMD'
      setcode do
        'AMD'
      end
    else
      setcode do
        ''
      end
    end
  else
    setcode do                          # If os familiy is not Debian or windows, output error
      'Error, OS not supported'
    end
  end
end
