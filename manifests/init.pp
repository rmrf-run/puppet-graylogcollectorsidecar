# Class: graylogcollectorsidecar
# ===========================
#
# Installs and configures graylog-collector-sidecar
# (https://github.com/Graylog2/collector-sidecar)
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `version`
# Select the version of the collector to install. Defaults to 'latest',
# which selects the latest available, stable release version
# * `api_url`
# Graylog server api url (e.g. http://graylog.example.com:9000/api)
# * `tags`
# An array of tags that the collector should be set up with
#
# Examples
# --------
#
# @example
#    class { 'graylogcollectorsidecar':
#      api_url => 'http://graylog.example.com:9000/api',
#      tags => [ 'apache.accesslog' ]
#    }
#
class graylogcollectorsidecar (
  $version = 'latest',
  $api_url,
  $tags
) {



}
