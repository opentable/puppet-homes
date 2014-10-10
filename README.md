# puppet-homes

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What is the homes module?](#module-description)
3. [Setup - The basics of getting started with homes](#setup)
    * [What homes affects](#what-homes-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with homes](#beginning-with-homes)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

The homes module allows you to create local system users and optionally manage their ssh keys

[![Build Status](https://secure.travis-ci.org/opentable/puppet-homes.png)](https://secure.travis-ci.org/opentable/puppet-homes.png)

##Module Description

This module provides a simplified way of managing local and system users, their home directory and optionally the distribution of their public and private ssh keys.

##Setup

###What homes affects

* Create users
* Populates authorized_keys file for the given user.


###Beginning with homes

To create a new local user:

```puppet
   $myuser = {
     'testuser' => { 'groups' => ['testgroup1', 'testgroup2'] }
   }

   homes { 'testuser':
     user => $myuser
   }
```

To create a new local user and manage their public ssh_key:

```puppet
   homes { 'testuser'
    ssh_key => 'AAAAB3NzaC1yc2EAAAADAQABAAAAgQC4U/G9Idqy1VvYEDCKg3noVChCbIrJAi0D/qMFoG=='
   }
```

##Usage

###Classes and Defined Types

####Defined Type: `homes`
The homes module primary type, `homes`, guides the basic setup of local users on your system.

**Parameters within `homes`:**
#####`user`
A hash giving details of the user that will be managed.

#####`ssh_key`
The ssh_key is the one-line contents of the users public key. This will be used to populate the authorized_keys file in the .ssh directory of the users home directory.

####Defined Type: `homes::ssh::private`
The type for managing the distribution of private keys from an existing key store.

**Parameters within `homes::ssh::private`:**
#####`username`
The name of the user that is being managed by this module.

#####`key_name`
The name of the private key as found in the existing key store.

#####`key_store`
The full path directory to the keystore where all the public keys and other secrets are located.

####Defined Type: `homes::ssh::config`
The type for managing the ssh config options for the user.

**Parameters within `homes::ssh::private`:**
#####`username`
The name of the user that is being managed by this module.

#####`ssh_config_entries`
A hash giving configuration details that will be set in the `~/.ssh/config` file

##Reference

###Defined Types
####Public Types
* [`homes`](#defined-homes): Guides the basic management of users.
* [`homes::ssh::private`](#defined-sshprivate): Management of a users private ssh key.
* [`homes::ssh::config`](#defined-sshconfig): Management of a users ssh config file.

####Private Types
* [`homes::home`](#defined-home): Create the user and manage the home directory.
* [`homes::ssh::public`](#defined-sshpublic): Management of a users public ssh key.

##Limitations

This module is tested on the following platforms:

* CentOS 5
* CentOS 6
* Ubuntu 12.04
* Ubuntu 14.04

It is tested with the OSS version of Puppet only.

###Contributing

Please read CONTRIBUTING.md for full details on contributing to this project.
