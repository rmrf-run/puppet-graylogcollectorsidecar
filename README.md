# dodevops/graylogcollectorsidecar
[![Travis](https://img.shields.io/travis/dodevops/puppet-graylogcollectorsidecar.svg)](https://travis-ci.org/dodevops/puppet-graylogcollectorsidecar)

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
  version => '0.1.0',
  tags => [ 'apache.accesslog' ]
}
```

Or using hiera:

```yaml
graylogcollectorsidecar::api_url: "http://graylog.example.com:9000/api"
graylogcollectorsidecar::version: "0.1.0"
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

Additionally, all other parameters as noted in the
[collector sidecar documentation](https://github.com/Graylog2/collector-sidecar/tree/cc9ce41be9bd571ddb3517533aca1026e7cdd298#configuration)
 can be specified.

The node_id will be set to the local hostname, if not specified.

## Limitations

This module uses the githubreleases module to download the graylog distribution package
from Github. However, Github imposes a [rate limiting](https://developer.github.com/v3/#rate-limiting)
on unauthenticated requests, which the module does (currently, this module doesn't
allow setting Github credentials).

So if you have a rather large deployment using this module, the rate limit might fail
the deployment. If so, you'll have to wait for the Rate limit to be reset.

If this is a constant pain, please [open an issue](https://github.com/dodevops/puppet-graylogcollectorsidecar/issues).

OS compatibility:

* Debian-Family (Ubuntu, Debian)
* RedHat-Family (RHEL, CentOS)