# 
# Custom fact to retrieve GPU vendor
# 
# @return A string with the name of the GPU vendor. 
#
# Returns an empty string if no GPU is detected or the vendor is not recognized. 
# If it outputs something else than 'NVIDIA', 'AMD' or '', an error occured.
#
Facter.add(:gpu_vendor) do
  osn = Facter.value(:os)['family']
  case osn
  when 'Debian'
                                       # Checks that facter is run as superuser
    if Facter::Core::Execution.exec('id -u') == '0'
                                       # Checks that pciutils is installed, if not - it is installed
      if Facter::Core::Execution.exec('apt-get install pciutils -y > /dev/null; echo $?') == '0'
                                       # Retrieves all GPUs with PCI vendor-ID
        vendor = Facter::Core::Execution.exec('lspci -nn | grep -i "VGA\|3D\|2D\|DISPLAY"')
        setcode do
          if vendor.include? "10de"    # Checks if at least one of the GPUs have NVIDIA's PCI vendor id
            'NVIDIA'
          elsif vendor.include? "1002" # Checks if at least one of the GPUs have AMD's PCI vendor id
            'AMD'
          else
            ''
          end
        end
      else
        setcode do                     # Returns an error if apt-get install pciutils returned something else than 0
          'Error while ensuring that pciutils is installed'
        end
      end
    else
      setcode do                       # Returns an error if facter was not run as superuser
        'Error, facter must be run as superuser'
      end
    end
  when 'windows'                       # Runs a powershell script that returns GPU vendor
    vendor = Facter::Core::Execution.exec("powershell \"Get-WmiObject Win32_VideoController | Foreach-Object { Write-Host $_.PNPDeviceId }\"")
    setcode do
      if vendor.include? 'VEN_10DE'
        'NVIDIA'
      elsif vendor.include? 'VEN_1002'
         'AMD'
      else
         ''
      end      
    end
  else
    setcode do                         # If os familiy is not Debian or windows, output error
      'Error, OS not supported'
    end
  end
end
