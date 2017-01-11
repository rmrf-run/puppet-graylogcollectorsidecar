# dodevops/graylogcollectorsidecar
[![Travis](https://img.shields.io/travis/dodevops/puppet-graylogcollectorsidecar.svg)](https://github.com/dodevops/puppet-graylogcollectorsidecar)

#### Table of Contents

1. [Description](#description)
1. [Setup](#setup)
    * [Beginning with graylogcollectorsidecar](#beginning-with-graylogcollectorsidecar)
1. [Reference](#reference)
1. [Limitations](#limitations)

## Description

This module installs and configures the [Graylog collector sidecar](https://github.com/Graylog2/collector-sidecar).

## Setup

### Beginning with graylogcollectorsidecar

To install the graylog collector sidecar, simply configure the class:

```puppet
class { 'graylogcollectorsidecar':
  api_url => 'http://graylog.example.com:9000/api',
  version => '0.1.0-beta.3',
  tags => [ 'apache.accesslog' ]
}
```

Or using hiera:

```yaml
graylogcollectorsidecar::api_url: "http://graylog.example.com:9000/api"
graylogcollectorsidecar::version: "0.1.0-beta.3"
graylogcollectorsidecar::tags:
    - apache.accesslog
```

## Reference

### class `graylogcollectorsidecar`

| Parameter | Description |
| --------- | ----------- |
| version | Select the version of the collector to install. Defaults to 'latest', which selects the latest available release version |
| api_url | Graylog server api url (e.g. http://graylog.example.com:9000/api) |
| tags | An array of tags that the collector should be set up with |

## Limitations

OS compatibility:

* Ubuntu/Debian