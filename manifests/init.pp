# Class: hashcat
# ===========================
#
# This module automates the installation of hashcat.
# The module allows you to specify whether you want to use CPU or GPU,
# but will automatically use the fastest hardware when used without parameters.
#
# The module works on Windows and Ubuntu, with both CPU and GPU.
#
#
# Parameters
# ----------
#
# processor: Specify processor, either 'cpu', 'gpu' or 'auto'. Default value is 'auto'.
# nvidia_version: Specify NVIDIA driver version to install (if using NVIDIA GPU). Default value is 'latest'.
# provider: Specify the package provider. Can be a PPA or 'universe' Default value is the PPA hash in the following example.
#
#
# Examples
# --------
#
# class { 'hashcat':
#   processor      => 'gpu',
#   nvidia_version => 367,
#   provider       => {
#     ppa       => 'ppa:ntnu-rgb/ppa',
#     id        => '470D3776F3131403C8680C7296FEB24BFAD547F7',
#     keyserver => 'keyserver.ubuntu.com',
#   }
# }
#
# Authors
# -------
#
# Henriette Kolby Rohde Garder <hkgarder@stud.ntnu.no>
# Sturla Høgdahl Bae <sturlaba@stud.ntnu.no>
#
# Copyright
# ---------
#
# Copyright 2017 Henriette K. Rohde Garder & Sturla H. Bae.
#
class hashcat(
  Enum['auto', 'gpu', 'cpu'] $processor = 'auto',
  Variant[
    Enum['universe'],                           # Can either be 'universe',
    Struct[{                                    # or a PPA. If PPA, the following must be provided:
      ppa       => Pattern[/\Appa:.*/],         # ppa must be a string beginning with "ppa:"
      id        => Pattern[/\A[[:xdigit:]]{8}\Z|\A[[:xdigit:]]{40}\Z/],  # Id must be a hexadecimal number 8 or 40 characters long
      keyserver => Pattern[/\./]                # Key-server name must contain at least 1 dot
    }]
  ] $provider = {                               # Will add a PPA as default because hashcat is not available in Universe for Ubuntu 16.04
    ppa       => 'ppa:ntnu-rgb/ppa',
    id        => '470D3776F3131403C8680C7296FEB24BFAD547F7',
    keyserver => 'keyserver.ubuntu.com',
  },
  Variant[Numeric, Enum['latest']] $nvidia_version = 'latest'
) {

  case $processor {
    'auto': {
      $gpu_vendor = $::facts['gpu_vendor']                 # Tries to identify GPU vendor
      case $gpu_vendor {
        'NVIDIA': {
          class { 'nvidia':
            version => $nvidia_version
          }
        }
        'AMD':    { include hashcat::amd      }
        '':       {
          $cpu_vendor = $facts['cpu_vendor']               # GPU vendor not detected, checking CPU vendor
          case $cpu_vendor {
            'Intel': { include hashcat::intel }
            'AMD':   { include hashcat::amd   }            # AMD GPU drivers contain the OpenCL libraries used by AMD CPUs.
            default: { fail($cpu_vendor)      }            # Error occured while identifying CPU vendor
          }
        }
        default:  { fail($gpu_vendor)       }              # Error occured while identifying GPU vendor
      }
    }
    'gpu': {
      $gpu_vendor = $::facts['gpu_vendor']                 # Tries to identify GPU vendor
      case $gpu_vendor {
        'NVIDIA': {
          class { 'nvidia':
            version => $nvidia_version
          }
        }
        'AMD':    { include hashcat::amd     }
        default:  { fail($gpu_vendor)        }               # Error occured while identifying GPU vendor 
      }
    }
    'cpu': {
      $cpu_vendor = $facts['cpu_vendor']
      case $cpu_vendor {
        'Intel': { include hashcat::intel }
        'AMD':   { include hashcat::amd   }                # AMD GPU drivers contain the OpenCL libraries used by AMD CPUs.
        default: { fail($cpu_vendor)      }                # Error occured while identifying CPU vendor
      }
    }
    default: {
      fail('Invalid processor name provided.')
    }
  }
  class { 'hashcat::install':                              # Installs the hashcat package
    provider => $provider
  }
}
