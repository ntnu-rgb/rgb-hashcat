# Class: hashcat::install::ubuntu
# ===========================
# 
# Installs hashcat. Calls different subclasses depending on OS.
#
class hashcat::install(
  Variant[Enum['universe'],Struct[{ppa => String, id => String, keyserver => String}]] $provider = {
    ppa          => 'ppa:ntnu-rgb/ppa',
    fingerprint  => '470D3776F3131403C8680C7296FEB24BFAD547F7',
    keyserver    => 'keyserver.ubuntu.com',
  },
) {
  if $::facts['os']['name'] == 'Ubuntu' {
    class { 'hashcat::install::ubuntu':
      provider => $provider
    }
  }
  elsif $::facts['os']['name'] == 'windows' {
    include hashcat::install::windows
  }
}
