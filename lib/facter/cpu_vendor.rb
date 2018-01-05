# 
# Custom fact to retrieve CPU vendor
# 
# @return A string with the name of the CPU vendor. 
#
# Returns an error if the vendor is not recognized.
#
Facter.add(:cpu_vendor) do
  cpu0 = Facter.value(:processors)['models'][0] # Retrieving first CPU/core (every machine should have at least 1 CPU/core)
  if cpu0.include? 'Intel'                      # Returns Intel if the name includes Intel
    setcode do
      'Intel'
    end
  elsif cpu0.include? 'AMD'                     # Returns AMD is the name includes AMD
    setcode do
      'AMD'
    end
  else
    setcode do                                  # Returns nothing if the name does not include Intel or AMD
      'Error, CPU vendor not detected'
    end
  end
end
