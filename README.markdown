Puppet Pip module
=================

[![Build Status](https://travis-ci.org/Yuav/puppet-pip.svg)](https://travis-ci.org/yuav/puppet-pip)

Less broken Puppet package provider for pip. Can also install and configure pip

## Module Description

The pip provider in Puppet is currently broken due to the fact that it's polling PyPI directly instead of relying on Pip from CLI

Installing this modules gives you a pip provider that works with;

 * Custom global PyPI repositories (since Pip 6.0)
 * Ensure latest
 * Proxies
 * Treat pip as a pip installable package

## Setup

If you don't use this module to manage python pip, it assumes pip is already installed and available in $PATH

### Beginning with pip

Just install the module:

    puppet module install yuav-pip

and use it as a custom provider

    package { 'Django':
      ensure   => 'latest',
      provider => 'yuavpip',
    }

*Note that pip needs to be installed prior to using the provider as in this example.

## Usage

To have pip installed using this module

    class { 'pip': }

Ensure pip is installed with the latest version

    class { 'pip':
      package_ensure => 'latest',
    }

Installing a global extra index

    class { 'pip':
      package_ensure => 'latest',
      extra_index_url => 'https://repo.fury.io/yuav/',
    }

    package { 'puppet-pip-test-project':
      ensure   => 'latest',
      provider => 'yuavpip',
      require  => Class['pip'], # Ensure custom repo is installed prior to my_package
    }

Installing a custom global PyPI repo

    class { 'pip':
      package_ensure => 'latest',
      index_url => 'http://devpi.fqdn:3141/repo/base/+simple/',
    }

    package { 'my_package':
      ensure   => 'latest',
      provider => 'yuavpip',
      require  => Class['pip'], # Ensure custom repo is installed prior to my_package
    }


*Note: By default this module use the vendor version of pip (E.G 1.0 for Ubuntu 12.04),
however global PyPI repo requires pip 6.0 or later. Since Puppet doesn't support ensure '>6.0',
use 'latest' to ensure a recent enough version
