# Class: hashcat::install::windows
# ===========================
# 
# This class installs hashcat on windows by installing a package from the chocolatey package repository
#
class hashcat::install::windows {

  include chocolatey

  package { 'hashcat':
    ensure   => installed,
    provider => 'chocolatey',
  }
}
