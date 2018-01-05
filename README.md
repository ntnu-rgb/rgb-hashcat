# hashcat

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with hashcat](#setup)
    * [Setup requirements](#setup-requirements)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Parameters](#parameters)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module automates the installation of hashcat.
The module allows you to specify whether you want to use CPU or GPU, but will automatically use the fastest hardware when used without parameters.

The module works on Windows and Ubuntu, with both CPU and GPU.

#### Description of hashcat

**hashcat** is the world's fastest and most advanced password recovery utility, supporting five unique modes of attack for over 200 highly-optimized hashing algorithms. hashcat currently supports CPUs, GPUs, and other hardware accelerators on Linux, Windows, and macOS, and has facilities to help enable distributed password cracking.

## Setup

Please follow these guidelines in order to preare your machine for using hashcat.

### Setup Requirements

Please make sure that all dependencies are met. Use the command `puppet module list --tree` to check that all necessary modules are present.

We recommend that you install the desired drivers before starting the installation, regardless of whether you are using AMD, NVIDIA, or Intel.
Hashcat can not be used unless there is at least one OpenCL device available. In almost all cases a GPU will be faster than a CPU for cracking passwords.

#### Intel CPU
**Ubuntu**: Install OpenCL runtime from <https://software.intel.com/en-us/articles/opencl-drivers#latest_CPU_runtime>.

#### AMD CPU
Follow the instructions at <http://support.amd.com/en-us/kb-articles/Pages/AMDGPU-PRO-Install.aspx> in order to install the latest drivers. The AMD GPU drivers provide the OpenCL libraries used by AMD CPUs.

#### AMD GPU
**Windows**: Download and install the latest drivers from <http://support.amd.com/en-us/download>

**Ubuntu**: Follow the instructions at <http://support.amd.com/en-us/kb-articles/Pages/AMDGPU-PRO-Install.aspx> in order to install the latest drivers.

#### NVIDIA GPU
**Ubuntu**: NVIDIA drivers will be automatically installed, but will require a reboot before the drivers can be used.
The hashcat team recommends downloading and installing the drivers directly from [NVIDIAs pages](http://www.nvidia.com/Download/index.aspx) for optimal performance.

#### Hashcat driver requirements
Hashcat requires the following versions of the different types of drivers:

+ AMD GPUs on Windows require "AMD Radeon Software Crimson Edition" (15.12 or later)
+ AMD GPUs on Linux require "AMDGPU-PRO Driver" (16.40 or later) 
+ Intel CPUs require "OpenCL Runtime for Intel Core and Intel Xeon Processors" (16.1.1 or later)
+ Intel GPUs on Windows require "OpenCL Driver for Intel Iris and Intel HD Graphics"
+ Intel GPUs on Linux require "OpenCL 2.0 GPU Driver Package for Linux" (2.0 or later)
+ NVIDIA GPUs require "NVIDIA Driver" (367.x or later)

## Usage

### Install Hashcat
**Install hashcat with default parameters:**

```
include hashcat
```

**Specify processor, NVIDIA driver version and provider using hiera:**
```
hashcat::processor: 'gpu'
hashcat::nvidia_version: 367
hashcat::provider: |
  {
    ppa       => 'ppa:ntnu-rgb/ppa',
    id        => '470D3776F3131403C8680C7296FEB24BFAD547F7',
    keyserver => 'keyserver.ubuntu.com',
  }
```
**Or by declaring a resource in your manifest:**

```
class { 'hashcat':
  processor => 'gpu',
  nvidia_version => 367,
  provider => {
    ppa       => 'ppa:ntnu-rgb/ppa',
    id        => '470D3776F3131403C8680C7296FEB24BFAD547F7',
    keyserver => 'keyserver.ubuntu.com',
  }
}
```
Note that hashcat is not available in the Ubuntu Universe repository for Ubuntu 16.04 as of writing this module.

## Reference

### Parameters
* **processor**
  * Specify what kind of processor you want to install necessary drivers and libraries for.
  * Possible values are `'auto'`, `'cpu'` or `'gpu'`.
  * Default value is `'auto'`, which will make the module install GPU drivers if there is a GPU present, and install CPU libraries if no GPU is present.

* **nvidia_version**
  * Specify which NVIDIA driver version should be installed.
  * Possible values are `'latest'` or `any valid number`
  * Default value is `'latest'`, which will make the module detect and install the latest drivers.
  * When specifying version, it is recommended to check that the parameter being passed is a valid version that is available in the package repositories. If the version is not available the installation will fail.

* **provider**
  * Specify the package provider for the hashcat package.
  * Possible values are a PPA hash or `'universe'`.
  * Note that as of writing this module hashcat is not available in official Ubuntu repositories for Ubuntu 16.04
  * The default value is: 
```
{
  ppa       => 'ppa:ntnu-rgb/ppa',
  id        => '470D3776F3131403C8680C7296FEB24BFAD547F7',
  keyserver => 'keyserver.ubuntu.com',
}
```

### Further reading
+ Hashcat's webpage: <https://hashcat.net/hashcat/>
+ How to use hashcat: <https://hashcat.net/wiki/>
+ Frequent asked questions about hashcat: <https://hashcat.net/wiki/doku.php?id=frequently_asked_questions>
+ Hashcat chocolatey package: <https://chocolatey.org/packages/hashcat/>
+ Default PPA: <https://launchpad.net/~ntnu-rgb/+archive/ubuntu/ppa>

## Limitations

The module is compatible with:

**OS:**

+ Ubuntu 14.04, Ubuntu 16.04
+ Windows Windows 7, Windows 8, Windows 10, Windows Server 2016 

**Hardware:**

+ AMD CPUs supporting OpenCL 1.2
+ Intel CPUs supporting OpenCL 1.2
+ AMD GPUs supporting OpenCL 1.2
+ NVIDIA CPUs supporting OpenCL 1.2

## Development

Everyone is welcome to contribute to the module, for instance by making a pull request.

Please report any issues that you experience, as long as they have not already been reported.
