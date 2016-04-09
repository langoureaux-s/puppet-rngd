# rngd

Tested with Travis CI

[![Build Status](https://travis-ci.org/bodgit/puppet-rngd.svg?branch=master)](https://travis-ci.org/bodgit/puppet-rngd)
[![Coverage Status](https://coveralls.io/repos/bodgit/puppet-rngd/badge.svg?branch=master&service=github)](https://coveralls.io/github/bodgit/puppet-rngd?branch=master)
[![Puppet Forge](http://img.shields.io/puppetforge/v/bodgit/rngd.svg)](https://forge.puppetlabs.com/bodgit/rngd)
[![Dependency Status](https://gemnasium.com/bodgit/puppet-rngd.svg)](https://gemnasium.com/bodgit/puppet-rngd)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with rngd](#setup)
    * [What rngd affects](#what-rngd-affects)
    * [Beginning with rngd](#beginning-with-rngd)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Classes and Defined Types](#classes-and-defined-types)
        * [Class: rngd](#class-rngd)
    * [Examples](#examples)
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

### Classes and Defined Types

#### Class: `sasl`

**Parameters within `rngd`:**

##### `hasstatus`

Whether the rngd service supports the status command or not.

##### `hwrng_device`

Specify the kernel device for random number input.

##### `package_ensure`

Intended state of the package providing the rngd daemon.

##### `package_name`

The package name that provides the rngd daemon.

##### `service_enable`

Whether to enable the rngd service.

##### `service_ensure`

Intended state of the rngd service.

##### `service_manage`

Whether to manage the rngd service or not.

##### `service_name`

The name of the rngd service.

### Examples

To configure rngd to use `/dev/urandom` for random number input:

```puppet
class { '::rngd':
  hwrng_device => '/dev/urandom',
}
```

If you want to use something else to manage the rngd daemon, you can do:

```puppet
class { '::rngd':
  service_manage => false,
}
```

## Reference

### Classes

#### Public Classes

* [`rngd`](#class-rngd): Main class for installing rngd daemon.

#### Private Classes

* `rngd::config`: Handles rngd daemon configuration.
* `rngd::install`: Handles rngd daemon installation.
* `rngd::params`: Different configuration data for different systems.
* `rngd::service`: Handles rngd daemon service.

## Limitations

This module has been built on and tested against Puppet 3.0 and higher.

The module has been tested on:

* RedHat Enterprise Linux 5/6/7
* Ubuntu 12.04/14.04
* Debian 6/7

Testing on other platforms has been light and cannot be guaranteed.

## Authors

Please log issues or pull requests at
[github](https://github.com/bodgit/puppet-rngd).
