# Class: hashcat::intel
# ===========================
# 
# Installs OpenCL runtime for Intel CPUs. Calls different subclasses depending on OS.
#
class hashcat::intel {
  if $facts['os']['name'] == 'Ubuntu' {
    include hashcat::intel::ubuntu
  }
  elsif $facts['os']['name'] == 'windows' {
    include hashcat::intel::windows
  }
}
