# Class: hashcat::amd
# ===========================
# 
# Checks if AMD drivers have been installed, and if they are not present an error is returned.
#
class hashcat::amd {

  $gpu_driver = $facts['gpu_driver']

  case $gpu_driver {
    'AMD':     {
      info('AMD drivers seem to be correctly installed')
    }
    'radeon':  {
      warning('AMD drivers does not seem to be installed. Please install the drivers manually in order to use hashcat.')
    }
    '':        {       # If no driver is recognized
      warning('AMD drivers does not seem to be installed. Please install the drivers manually in order to use hashcat.')
    }
    'NVIDIA':  {       # In case NVIDIA drivers are detected on a AMD gpu
      warning('It seems the module has detected that you are running NVIDIA drivers on an AMD GPU, please report this to the developer')
    }
    'nouveau': {       # In case NVIDIA drivers are detected on a AMD gpu
      warning('It seems the module has detected that you are running NVIDIA drivers on an AMD GPU, please report this to the developer')
    }
    default:   {       # Print out error
      fail($gpu_driver)
    }
  }
}
