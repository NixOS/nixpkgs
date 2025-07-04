{
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RimGU3zzc1q188D1V/FBVdd49LQ+pPSFqd65yPfFgjI=";
      type = "gem";
    };
    version = "2.8.7";
  };
  aws-eventstream = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-fiw6Vcpw14YdXTyY5H2qRj7VOcNJyroitIMFuJGVctc=";
      type = "gem";
    };
    version = "1.3.2";
  };
  aws-partitions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-wtl6Ql2QBHrM8AHnJ4b18SaaxNbp4o7Mjhawpu2Xqkk=";
      type = "gem";
    };
    version = "1.1064.0";
  };
  aws-sdk-cloudwatchlogs = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HHY8RfuVzHf5RuysHAQbwvCYLfKEo9AZiJWjiKgC7cc=";
      type = "gem";
    };
    version = "1.109.0";
  };
  aws-sdk-core = {
    dependencies = [
      "aws-eventstream"
      "aws-partitions"
      "aws-sigv4"
      "base64"
      "jmespath"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nhDM/WPIBh+3Cg8eJs992By1BwkxMBUB+29JWHzFTTI=";
      type = "gem";
    };
    version = "3.220.1";
  };
  aws-sdk-firehose = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-MWwAlZg7a20aMa2CnCw2jMnnR6xntEV5a0WUJ92BPus=";
      type = "gem";
    };
    version = "1.89.0";
  };
  aws-sdk-kinesis = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+vzOhLdVzOACXBc38NcOohHEpg8PedaRJ8eocQbT3OE=";
      type = "gem";
    };
    version = "1.74.0";
  };
  aws-sdk-kms = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uikvw//WclMqriYB/lX/Qk7ueNqOI8I7ps5ANxOCdag=";
      type = "gem";
    };
    version = "1.99.0";
  };
  aws-sdk-s3 = {
    dependencies = [
      "aws-sdk-core"
      "aws-sdk-kms"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0Pw1eTlctstpv26XUkDOAx/GcxkOdMjd291sGFcrRQ0=";
      type = "gem";
    };
    version = "1.182.0";
  };
  aws-sdk-sqs = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-74iWLeNq1q9W7wf07QVDPevD1CcyXmytQXSkWW2TZZk=";
      type = "gem";
    };
    version = "1.93.0";
  };
  aws-sigv4 = {
    dependencies = [ "aws-eventstream" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UKh5aZGoYjJEQgNq16OVkgVyuEu2zSm5ReXhgA6Nods=";
      type = "gem";
    };
    version = "1.11.0";
  };
  base64 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DyXpshoCoMwM6o75KyBBA105NQlG6HicVistGj2gFQc=";
      type = "gem";
    };
    version = "0.2.0";
  };
  bson = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EyZmEf3n3MW9Y9FH5q5zAKNQDLPS+p+dPG37/3PSb6c=";
      type = "gem";
    };
    version = "4.15.0";
  };
  concurrent-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gTs+N6ym3yoho7nx1Jf4y6skorlMqzJb/+Ze4PbL68Y=";
      type = "gem";
    };
    version = "1.3.5";
  };
  "cool.io" = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6iqiAFm4AMvY5j86+XWqh4ccpa950tojHPVa/U3MgzI=";
      type = "gem";
    };
    version = "1.9.0";
  };
  csv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-b/DBNeZeSF0YZN3mwXA7YNNMyeGb7YRSg0oLKKUZvU4=";
      type = "gem";
    };
    version = "3.3.2";
  };
  digest-crc = {
    dependencies = [ "rake" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZK3COiaiQQRMvmcyR3yhs8KB154iQLz/J1o3paDXjAc=";
      type = "gem";
    };
    version = "0.7.0";
  };
  drb = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6dRyv3hfVYuWslNYuuEVZG2g2/1FEHrYWLC8DZNcs0A=";
      type = "gem";
    };
    version = "2.2.1";
  };
  elastic-transport = {
    dependencies = [
      "faraday"
      "multi_json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tenkBsmKhn3HOpx8Lyn69hneOt6Uqht/Wo3PRf/A5Xc=";
      type = "gem";
    };
    version = "8.4.0";
  };
  elasticsearch = {
    dependencies = [
      "elastic-transport"
      "elasticsearch-api"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-aX2Asfa7/99Zh3M079kedESq9+d1Cc1whMAAXVxofNk=";
      type = "gem";
    };
    version = "8.17.1";
  };
  elasticsearch-api = {
    dependencies = [ "multi_json" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xoQSdYR+WzdQbHL+9pbMZ8xZpBdklO2gtwOMFjs4lMc=";
      type = "gem";
    };
    version = "8.17.1";
  };
  excon = {
    dependencies = [ "logger" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ygQLthvABZlo80oXEVoA0tuFYuPAxcXHQyBytVHIWp0=";
      type = "gem";
    };
    version = "1.2.5";
  };
  faraday = {
    dependencies = [
      "faraday-net_http"
      "json"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-FXM5wlx7i8tzn1zxIHywzv6PocZQJyZry8NMkMhLmtY=";
      type = "gem";
    };
    version = "2.12.2";
  };
  faraday-excon = {
    dependencies = [
      "excon"
      "faraday"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xfxxdasoSxZEllWeNfVQWH7FsCizzbtAt+voOqfltXU=";
      type = "gem";
    };
    version = "2.3.0";
  };
  faraday-net_http = {
    dependencies = [ "net-http" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ofHkzWos8hWZyCIVleJ1gtmTaBmXe71AiaYB8kxk5Uo=";
      type = "gem";
    };
    version = "3.4.0";
  };
  fluent-config-regexp-type = {
    dependencies = [ "fluentd" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-9R3PIk8GWsNGT/SkYeP50b8iB+pj+3iNPS0uWlnfYEI=";
      type = "gem";
    };
    version = "1.0.0";
  };
  fluent-plugin-cloudwatch-logs = {
    dependencies = [
      "aws-sdk-cloudwatchlogs"
      "fluentd"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-S15ZFf1Umj2zUP01s/KmzdKWtCUggCthRQH5SjY+LY0=";
      type = "gem";
    };
    version = "0.14.3";
  };
  fluent-plugin-concat = {
    dependencies = [ "fluentd" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-c1jOapgQxyViEqzp/bHnX7gNF/ufvVqjY2xrJjM0P60=";
      type = "gem";
    };
    version = "2.5.0";
  };
  fluent-plugin-elasticsearch = {
    dependencies = [
      "elasticsearch"
      "excon"
      "faraday"
      "faraday-excon"
      "fluentd"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-azGwEExX24srzEUMMNajGBXN+fwxE4s+X1V/8kVS+qY=";
      type = "gem";
    };
    version = "5.4.3";
  };
  fluent-plugin-kafka = {
    dependencies = [
      "fluentd"
      "ltsv"
      "ruby-kafka"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YW/j7qzWQOfpo6D+gk+v0OwISpzIod1zFoTkKMQPf1w=";
      type = "gem";
    };
    version = "0.19.3";
  };
  fluent-plugin-kinesis = {
    dependencies = [
      "aws-sdk-firehose"
      "aws-sdk-kinesis"
      "fluentd"
      "google-protobuf"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-P9NGtOBv55Stq+0QbqeoQBjrZ9W9+6F6o7IHmBRBnYs=";
      type = "gem";
    };
    version = "3.5.0";
  };
  fluent-plugin-mongo = {
    dependencies = [
      "fluentd"
      "mongo"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1Umz9o1Q4qPOXTSst73Pfox9WHFRf2YpArz/y51RbtQ=";
      type = "gem";
    };
    version = "1.6.0";
  };
  fluent-plugin-record-reformer = {
    dependencies = [ "fluentd" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dqpThZS9wHabVFg0KwGAfuPEBiVswEhwokTHFL3Ljr8=";
      type = "gem";
    };
    version = "0.9.1";
  };
  fluent-plugin-rewrite-tag-filter = {
    dependencies = [
      "fluent-config-regexp-type"
      "fluentd"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Rq9+YIG7lrqFha/4oGrT9EWWk7lKrQZoE5QdBC+yW+4=";
      type = "gem";
    };
    version = "2.4.0";
  };
  fluent-plugin-s3 = {
    dependencies = [
      "aws-sdk-s3"
      "aws-sdk-sqs"
      "fluentd"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SVY0WGEyaO42ZYwTOovMzoQtc0oSPoNASt8VGYo/9DA=";
      type = "gem";
    };
    version = "1.8.3";
  };
  fluent-plugin-webhdfs = {
    dependencies = [
      "fluentd"
      "webhdfs"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-I05lc2Eai9i3Fp9Aad/dwbJlbAlWwJtlns1TH6Y7Etc=";
      type = "gem";
    };
    version = "1.6.0";
  };
  fluentd = {
    dependencies = [
      "base64"
      "cool.io"
      "csv"
      "drb"
      "http_parser.rb"
      "logger"
      "msgpack"
      "serverengine"
      "sigdump"
      "strptime"
      "tzinfo"
      "tzinfo-data"
      "webrick"
      "yajl-ruby"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DclHGAwiKnMOpoUWsTrJNiewQ7l0r4rbbA3fByNoDoA=";
      type = "gem";
    };
    version = "1.18.0";
  };
  google-protobuf = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-u2aL88QAzRDFdlJMksxQFdrLZrtFc9eaHKnvGHk+EDw=";
      type = "gem";
    };
    version = "3.25.6";
  };
  "http_parser.rb" = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Wgky8fqCzgioUWomhdWoYDHAAFYPiZRpE8VVoGl1RL4=";
      type = "gem";
    };
    version = "0.8.0";
  };
  jmespath = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-I413SlhyPWwJBJTIh5temRjBlIX36EDywcdTLPhOvLE=";
      type = "gem";
    };
    version = "1.6.2";
  };
  json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3ciK2Robrz8AOMF08lOvOwhtMNx02xfKQlm73pgvlNw=";
      type = "gem";
    };
    version = "2.10.1";
  };
  logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3WGNJOY3cVRycy5+7QLjPPvfVt6q0iXt0PH4nTgCQBc=";
      type = "gem";
    };
    version = "1.6.6";
  };
  ltsv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2sNcLohfyHXcexyHl7VX22h5XKbOhymMvfCnAwrbMnM=";
      type = "gem";
    };
    version = "0.1.2";
  };
  mongo = {
    dependencies = [ "bson" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DsJXEx1FH8LznCfPtzQjoD5HNwGkwoUO/TDhInruNnY=";
      type = "gem";
    };
    version = "2.18.3";
  };
  msgpack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5kzgISAA0BaAn1BItI6zpl/7Fp2yIjj7S3JHL+yy1zI=";
      type = "gem";
    };
    version = "1.8.0";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-H9BBOLbkqQAX6NG4BMA5AxOZhm/z+6u3girqNnx4YV0=";
      type = "gem";
    };
    version = "1.15.0";
  };
  net-http = {
    dependencies = [ "uri" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-liGyDBN4mK+diQVWhIyTYDcWyrUW3CyJsBo4uJTiWfs=";
      type = "gem";
    };
    version = "0.6.0";
  };
  public_suffix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YdROHKtcu75bMQaEgc8Wl23Q3BtrB72VYX74xePgDG8=";
      type = "gem";
    };
    version = "6.0.1";
  };
  rake = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Rss42uZdfXS2AgpKydSK/tjrgUnAQOzPBSO+yRkHBZ0=";
      type = "gem";
    };
    version = "13.2.1";
  };
  ruby-kafka = {
    dependencies = [ "digest-crc" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-92RpRObHK6NBPiFCP/TVELIuOrdgrHCUCjZY4OV2I44=";
      type = "gem";
    };
    version = "1.5.0";
  };
  serverengine = {
    dependencies = [
      "base64"
      "logger"
      "sigdump"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SkKkMfGH+smQaDTRus8AMh6DWxG8f3uK9fm1yPvSRrw=";
      type = "gem";
    };
    version = "2.4.0";
  };
  sigdump = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-u3BsHM5wRYsoXSw6VxIegBzLefaL5/c3dpLrQLVDckI=";
      type = "gem";
    };
    version = "0.2.5";
  };
  strptime = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mO13/3cXpHOHukc2FPR454sWLXCmQHL9cdVPVH4Hmvk=";
      type = "gem";
    };
    version = "0.2.5";
  };
  tzinfo = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ja+CjMd7z31jsOO9tsqkfiJy3Pr0+/5G+MOp3wh6gps=";
      type = "gem";
    };
    version = "2.0.6";
  };
  tzinfo-data = {
    dependencies = [ "tzinfo" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LYwaUBqT8myy4KUBnAfx3q73bpnMozCPW9zajkEf3ws=";
      type = "gem";
    };
    version = "1.2025.1";
  };
  uri = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6fIkRgjuove8NX2VTGXJEM4DmcpeGKeikgesIth2cBE=";
      type = "gem";
    };
    version = "1.0.3";
  };
  webhdfs = {
    dependencies = [ "addressable" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0TDoKknx+v+ml8tWu+dAObxF5HIoDDEXiSUdwos465Q=";
      type = "gem";
    };
    version = "0.11.0";
  };
  webrick = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tC08lPFm8/tz2H6bNZ3vm1g2xCb8i+rPOPIYSiGyqYk=";
      type = "gem";
    };
    version = "1.9.1";
  };
  yajl-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jJdNnBGuB7CjttJu/qhAcmmwLkE4EY++PvDS7Jck0dI=";
      type = "gem";
    };
    version = "1.4.3";
  };
}
