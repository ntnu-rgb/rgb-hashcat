#
# * Install hashcat using default parameters:
#
include hashcat
#
# * Install hashcat and pass parameters:
#
class { 'hashcat':
  processor      => 'gpu',
  nvidia_version => 367,
  provider       => {
    ppa       => 'ppa:ntnu-rgb/ppa',
    id        => '470D3776F3131403C8680C7296FEB24BFAD547F7',
    keyserver => 'keyserver.ubuntu.com',
  }
}
#
# * Install hashcat with data from hiera:
#
# In puppet manifest:
include hashcat
# And in common.yml:
# ---
# hashcat::processor: 'gpu'
# hashcat::nvidia_version: 367
# hashcat::provider: 'universe'
