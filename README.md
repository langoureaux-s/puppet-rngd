# rngd

Tested with Travis CI

[![Build Status](https://travis-ci.org/bodgit/bodgit-rngd.svg?branch=master)](https://travis-ci.org/bodgit/bodgit-rngd)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with rngd](#setup)
    * [What rngd affects](#what-rngd-affects)
    * [Beginning with rngd](#beginning-with-rngd)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module manages rngd.

## Module Description

The module basically makes sure the rngd daemon is installed and started,
that's pretty much it. The rngd daemon does a good job at working out where
the source of hardware entropy is so there's no configuration required.

## Setup

### What rngd affects

* The package containing the rngd daemon.
* The service controlling the rngd daemon.

### Beginning with rngd

```puppet
include ::rngd
```

## Usage

If you want to use something else to manage the rngd daemon, you can do:

```puppet
class { '::rngd':
  service_manage => false,
}
```

## Reference

### Classes

* rngd: Main class for installation and service management.
* rngd::install: Handles package installation.
* rngd::params: Different configuration data for different systems.
* rngd::service: Handles the rngd service.

### Parameters

####`package_ensure`

Intended state of the package providing the rngd daemon.

####`package_name`

The package name that provides the rngd daemon.

####`service_enable`

Whether to enable the rngd service.

####`service_ensure`

Intended state of the rngd service.

####`service_manage`

Whether to manage the rngd service or not.

####`service_name`

The name of the rngd service.

## Limitations

This module has been built on and tested against Puppet 2.7 and higher.
Puppet 2.7 support is slated for removal at the next major version.

The module has been tested on:

* RedHat Enterprise Linux 5/6/7

Testing on other platforms has been light and cannot be guaranteed.

## Authors

* Matt Dainty <matt@bodgit-n-scarper.com>
