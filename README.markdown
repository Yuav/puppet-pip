#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with pip](#setup)
    * [What pip affects](#what-pip-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with pip](#beginning-with-pip)
4. [Usage - Configuration options and additional functionality](#usage)

## Overview

Working Puppet package provider for pip. Can also install and configure pip

## Module Description

The pip provider in Puppet is currently broken due to the fact that it's polling PyPI directly instead of relying on Pip from CLI

Installing this modules gives you a pip provider that works with;

 * Custom PyPI repositories
 * Ensure latest
 * Proxies
 * Treat pip as a pip installable package

## Setup

### What pip affects

* A list of files, packages, services, or operations that the module will alter, impact, or execute on the system it's installed on.
* This is a great place to stick any warnings.
* Can be in list or paragraph form.

### Setup Requirements **OPTIONAL**

If you don't use this module to manage python pip, it assumes pip is already installed and available in $PATH

### Beginning with pip

Just install the module:

    puppet module install yuav-pip

and use it as a custom provider

    package { 'Django':
      ensure => 'latest',
      provider => 'yuavpip',
    }

*Note that pip needs to be installed prior to using this provider. Use a require statement to ensure correct order

## Usage

To have pip installed using this module

    class { 'pip': }
