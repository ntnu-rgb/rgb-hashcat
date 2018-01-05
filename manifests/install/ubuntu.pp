# Class: hashcat::install::ubuntu
# ===========================
# 
# This class installs hashcat on ubuntu by installing a package from a specified or default package repository
#
class hashcat::install::ubuntu(
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
  }
) {

  unless $provider == 'universe' {
    class { 'apt':
      keys   => {
        'ppa-key' => {
          id     => $provider['id'],
          server => $provider['keyserver'],
        },
      },
      ppas   => {
        $provider['ppa'] => { },
      },
      update => {
        frequency => 'always',
      },
      before => Package['hashcat']
    }
  }

  package { 'hashcat':
    ensure  => installed,
  }
}
