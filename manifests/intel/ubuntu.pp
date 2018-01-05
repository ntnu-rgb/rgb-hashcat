# Class: hashcat::intel::ubuntu
# ===========================
# 
# Installs OpenCL runtime for Intel CPUs on Ubuntu. 
# Prints a message that describes how to install additional components that might be missing and cannot be installed with puppet.
#
class hashcat::intel::ubuntu {

  package { 'ocl-icd-libopencl1':
    ensure => installed,
  }

  package { 'opencl-headers':
    ensure => installed,
  }

  package { 'clinfo':
    ensure => installed,
  }

  package { 'lsb-core':
    ensure => installed,
  }

  warning('In order to run hashcat on an Intel CPU, please make sure that Intel OpenCL runtime is installed. \
It can be downloaded from: https://software.intel.com/en-us/articles/opencl-drivers#latest_CPU_runtime')
}
