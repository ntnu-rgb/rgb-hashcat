# Class: hashcat::intel::ubuntu
# ===========================
# 
# Installs OpenCL runtime for Intel CPUs on Windows by downloading a package from the chocolatey package repository.
#
class hashcat::intel::windows {

  include chocolatey

  package { 'opencl-intel-cpu-runtime':
    ensure   => installed,
    provider => 'chocolatey',
  }
}
