{
  actioncable = {
    dependencies = [
      "actionpack"
      "activesupport"
      "nio4r"
      "websocket-driver"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dkY3tbLZe5TkEtViwXe/0WsP12nVXJiEY2L1Jj6Kqg0=";
      type = "gem";
    };
    version = "7.1.5.1";
  };
  actionmailbox = {
    dependencies = [
      "actionpack"
      "activejob"
      "activerecord"
      "activestorage"
      "activesupport"
      "mail"
      "net-imap"
      "net-pop"
      "net-smtp"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-w8IFif5D5vqIu6LXam+YBf/dAlMfSppK+Bl9WfWlNgo=";
      type = "gem";
    };
    version = "7.1.5.1";
  };
  actionmailer = {
    dependencies = [
      "actionpack"
      "actionview"
      "activejob"
      "activesupport"
      "mail"
      "net-imap"
      "net-pop"
      "net-smtp"
      "rails-dom-testing"
    ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-shPW2ICyOwk8z+87T4ej0n5GZkQvcbW2NLLRnhmkl1k=";
      type = "gem";
    };
    version = "7.1.5.1";
  };
  actionpack = {
    dependencies = [
      "actionview"
      "activesupport"
      "nokogiri"
      "racc"
      "rack"
      "rack-session"
      "rack-test"
      "rails-dom-testing"
      "rails-html-sanitizer"
    ];
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-K8Jj2fQ/Fsw7M2D1llmrEfFAV3YC83HxqWjiZys41xg=";
      type = "gem";
    };
    version = "7.1.5.1";
  };
  actiontext = {
    dependencies = [
      "actionpack"
      "activerecord"
      "activestorage"
      "activesupport"
      "globalid"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uOJhz61bxqeLPxW+Xnx/MhkAQbPcbwJ6OjU7Q5LS9+w=";
      type = "gem";
    };
    version = "7.1.5.1";
  };
  actionview = {
    dependencies = [
      "activesupport"
      "builder"
      "erubi"
      "rails-dom-testing"
      "rails-html-sanitizer"
    ];
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jFWaITUBeY4ptQtTQaZDpwu/b6CqKrr1cdDvxZ3E9qo=";
      type = "gem";
    };
    version = "7.1.5.1";
  };
  active_model_serializers = {
    dependencies = [
      "actionpack"
      "activemodel"
      "case_transform"
      "jsonapi-renderer"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-FN4XfIQ6ih7bx+lU63Y3B0sa8tztO9hFQXO8BuyNwY4=";
      type = "gem";
    };
    version = "0.10.14";
  };
  activejob = {
    dependencies = [
      "activesupport"
      "globalid"
    ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-djM3bIV/TEkdBrWn9dhtnwevxZU5g1Sj8avoDrfjV2c=";
      type = "gem";
    };
    version = "7.1.5.1";
  };
  activemodel = {
    dependencies = [ "activesupport" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dHJ0ZoVKf73+jycCyjESsjh3UA1JJr9+AukhrVQhkfE=";
      type = "gem";
    };
    version = "7.1.5.1";
  };
  activerecord = {
    dependencies = [
      "activemodel"
      "activesupport"
      "timeout"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-9ArRYJvzO5ulvcThbYCnexUXFTI0zrQT0x1jXXuR8eM=";
      type = "gem";
    };
    version = "7.1.5.1";
  };
  activestorage = {
    dependencies = [
      "actionpack"
      "activejob"
      "activerecord"
      "activesupport"
      "marcel"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-rmuLB2hYxmbqrW+JbXhrZ2VCNehh4kqD9h8cyXtD/2M=";
      type = "gem";
    };
    version = "7.1.5.1";
  };
  activesupport = {
    dependencies = [
      "base64"
      "benchmark"
      "bigdecimal"
      "concurrent-ruby"
      "connection_pool"
      "drb"
      "i18n"
      "logger"
      "minitest"
      "mutex_m"
      "securerandom"
      "tzinfo"
    ];
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nwxILkc7mGjLPf4+nbVJo70jAsAuT1laXKrBRKjHz7g=";
      type = "gem";
    };
    version = "7.1.5.1";
  };
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RimGU3zzc1q188D1V/FBVdd49LQ+pPSFqd65yPfFgjI=";
      type = "gem";
    };
    version = "2.8.7";
  };
  aes_key_wrap = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uTX0dWs3N1iV20VmnnnfzcD3kB4S1OCJdNVUDI4HdqU=";
      type = "gem";
    };
    version = "1.1.0";
  };
  android_key_attestation = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Rn6wGpnSu0jvnPJMwTcSZp1wVsulpS0AlVT/A3VgVws=";
      type = "gem";
    };
    version = "0.3.0";
  };
  annotate = {
    dependencies = [
      "activerecord"
      "rake"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mmG6ofsTiAqjqNn2JVOIm7Kjt5cPiLvGbTrHWlZ3gNM=";
      type = "gem";
    };
    version = "3.2.0";
  };
  ast = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HigCMuajN1TN5UK8XvhVILdNsqrHPsFKzvRTeERHzBI=";
      type = "gem";
    };
    version = "2.4.2";
  };
  attr_required = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8Ov8VrNeh09NCueZBm28H4Hv7+I2TKOAPcnqak3my5k=";
      type = "gem";
    };
    version = "1.0.2";
  };
  awrence = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3R0hTBKpH0SdHvgdfuO6vCgWlE5FB1LnUixlUhhySD4=";
      type = "gem";
    };
    version = "1.2.1";
  };
  aws-eventstream = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8UNMwDqyJIdW6wLPpF6QDlmgYdf73Eqf2Cpd0j15bT8=";
      type = "gem";
    };
    version = "1.3.0";
  };
  aws-partitions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-AXIWgtI3SePCJsu7PyKjM4MPu2p9nRajnsUFPn5vpN4=";
      type = "gem";
    };
    version = "1.978.0";
  };
  aws-sdk-core = {
    dependencies = [
      "aws-eventstream"
      "aws-partitions"
      "aws-sigv4"
      "jmespath"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-e3CqhefrRRz3ydStN5e2EY1OCoMn+LKMPbEGeEs+qEI=";
      type = "gem";
    };
    version = "3.209.0";
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
      hash = "sha256-sMYjGZ8fRr2CwdH6D+7xBauM/GvS9kPXHNHCieEanak=";
      type = "gem";
    };
    version = "1.94.0";
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
      hash = "sha256-V8mcsykZz3y57JRqtaj7094MS19WfPtr1ejJ2+ng/H4=";
      type = "gem";
    };
    version = "1.166.0";
  };
  aws-sigv4 = {
    dependencies = [ "aws-eventstream" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-FZsRPck/n6WhNgOovQnqtUqaDo+Y5ga0fxzuUEeA35w=";
      type = "gem";
    };
    version = "1.10.0";
  };
  azure-storage-blob = {
    dependencies = [
      "azure-storage-common"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YbdhGIQ8kXdr0kvuIsdK2v63xLs6hYoyUEfa47WdA2M=";
      type = "gem";
    };
    version = "2.0.3";
  };
  azure-storage-common = {
    dependencies = [
      "faraday"
      "faraday_middleware"
      "net-http-persistent"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YI9NqrDga1g7c9z/0yRuo554BW3jFjAoawz5evfWlWs=";
      type = "gem";
    };
    version = "2.0.4";
  };
  base64 = {
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DyXpshoCoMwM6o75KyBBA105NQlG6HicVistGj2gFQc=";
      type = "gem";
    };
    version = "0.2.0";
  };
  bcp47_spec = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-P9Yu35bBJr2WJOQxmsdAgqlmCBhZ0e4O88MEFkCjeBA=";
      type = "gem";
    };
    version = "0.2.1";
  };
  bcrypt = {
    groups = [
      "default"
      "pam_authentication"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hBD4x7PtVKPADNJFa/E5F9aVEX8DMhjiSDsuQLB4QJk=";
      type = "gem";
    };
    version = "3.1.20";
  };
  benchmark = {
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DxL4xJVUXjcQw+TwSA9j8GtMhCzJTOx/M6lW9RgOh0o=";
      type = "gem";
    };
    version = "0.4.0";
  };
  better_errors = {
    dependencies = [
      "erubi"
      "rack"
      "rouge"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-95jxusk/PndZJbf8skz/vPC7Yu4iEPU1DxYaa3X8CnM=";
      type = "gem";
    };
    version = "2.10.1";
  };
  bigdecimal = {
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qJRn7VpE+K4Bgkr0nLxXWHH6B4My6Pd+pCVyXB/+J74=";
      type = "gem";
    };
    version = "3.1.8";
  };
  bindata = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KdzLi6HMneFI8ku4iTCEDGLbVnFfD4Dsyt1iTZ89JiM=";
      type = "gem";
    };
    version = "2.5.0";
  };
  binding_of_caller = {
    dependencies = [ "debug_inspector" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KykCq/9CRt3PvE2ptpvEoBniKuswDC/2KJoXPUuQspo=";
      type = "gem";
    };
    version = "1.0.1";
  };
  blurhash = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-isHb0tE25N/SJY72pOl7iv48t+ZxYBuK1GfRKqBB0fI=";
      type = "gem";
    };
    version = "0.1.8";
  };
  bootsnap = {
    dependencies = [ "msgpack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-rExCrzl/fuFVIYIBmNrv9UXkw2DSdyxgH73CwH2Sr1U=";
      type = "gem";
    };
    version = "1.18.4";
  };
  brakeman = {
    dependencies = [ "racc" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hi5wnKoavwDdDEcEVoJATDSfZIdse+dKjmpNa+X2Gh0=";
      type = "gem";
    };
    version = "6.2.1";
  };
  browser = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YnRTAXAf8sbF0y0He7ElMrIL4mGSnctSxnge0NVlizw=";
      type = "gem";
    };
    version = "5.3.1";
  };
  brpoplpush-redis_script = {
    dependencies = [
      "concurrent-ruby"
      "redis"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NBHcCG0JOQi/PTzjkjz3ZCOBcRMafawzTRtW7Iv8pdk=";
      type = "gem";
    };
    version = "0.1.3";
  };
  builder = {
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SXkY0vncpSj9ykuI2E5O9DhyVtmEuBVOnV0/5anIg18=";
      type = "gem";
    };
    version = "3.3.0";
  };
  bundler-audit = {
    dependencies = [ "thor" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cwUdqgmGXENkUKNcTYfO7xXz+Xd/Sq1P0BXMbx8rEEg=";
      type = "gem";
    };
    version = "0.9.2";
  };
  capybara = {
    dependencies = [
      "addressable"
      "matrix"
      "mini_mime"
      "nokogiri"
      "rack"
      "rack-test"
      "regexp_parser"
      "xpath"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QtunIFeOocpl/XpB0WPdNoUCwZGARVj24PcbORBUru8=";
      type = "gem";
    };
    version = "3.40.0";
  };
  case_transform = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4q1EGNzusifPR0zDMs1QBMlcE2wEGGwczqrYq43m/js=";
      type = "gem";
    };
    version = "0.2";
  };
  cbor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nuCX/FjZvF5AbREs0tThEsc1TsFvi2/zTkcyweRLTrc=";
      type = "gem";
    };
    version = "0.5.9.8";
  };
  charlock_holmes = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tJ6KEc4ZIeLFtlURu4ZK5RcgzpvRwzbM8OiebIrmLbA=";
      type = "gem";
    };
    version = "0.7.9";
  };
  chewy = {
    dependencies = [
      "activesupport"
      "elasticsearch"
      "elasticsearch-dsl"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-S9Q94HThUWp3k/v7LMCUPyPgXexBtxzisTQBzeCR+E0=";
      type = "gem";
    };
    version = "7.6.0";
  };
  childprocess = {
    dependencies = [ "logger" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mo1IS+L9QJag6QoM0+RJoFvDqjP4rJ5Nbc72rBRVtuw=";
      type = "gem";
    };
    version = "5.1.0";
  };
  chunky_png = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-idWzG1XAz02jz4mitOvDF42Kvoy68Rah26lWaFAv3P4=";
      type = "gem";
    };
    version = "1.4.0";
  };
  climate_control = {
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NrIYlhk/qMhTb6HNhDoHz43b0DqrpDZl4mxT7BvXCqU=";
      type = "gem";
    };
    version = "1.2.0";
  };
  cocoon = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0I8U5pZTKH16Bg7kM4m4yCTlUZHf+8oMXFhvOO9JHw0=";
      type = "gem";
    };
    version = "1.2.15";
  };
  color_diff = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mdw59EU+Qqo7vG1zj4IZSHC5dJkxNc7mHesu/ynetwU=";
      type = "gem";
    };
    version = "0.1";
  };
  concurrent-ruby = {
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1KqSYzmwqGtbUFSgqMWAFj5vXcvf0PS7kWsaJXBzHDI=";
      type = "gem";
    };
    version = "1.3.4";
  };
  connection_pool = {
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-D0DPmXCR8fBP9m2mfqvWGp/g1JKLmjZFIoUyUS+rYvQ=";
      type = "gem";
    };
    version = "2.4.1";
  };
  cose = {
    dependencies = [
      "cbor"
      "openssl-signature_algorithm"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1dTbzWsDXVE+3E4aubwQ6c4TtAEcluPRuP5eZBP9beU=";
      type = "gem";
    };
    version = "1.3.1";
  };
  crack = {
    dependencies = [
      "bigdecimal"
      "rexml"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-yDrv20KM3Htmx/KH5IjHlvBVwIOeblRf7CxwR3Q8Skk=";
      type = "gem";
    };
    version = "1.0.0";
  };
  crass = {
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3FFgIqVuezsVYJmryBttKwjqHtEmdqx6VldhfwEr1F0=";
      type = "gem";
    };
    version = "1.0.6";
  };
  css_parser = {
    dependencies = [ "addressable" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CoOZtTmPxfV8YoIZz2kOzYg0D1gwlIYEJD88DiNoQ3c=";
      type = "gem";
    };
    version = "1.19.0";
  };
  csv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-C70d79wxE0q+/tAnpjmzcjwnU4YhUPTD7mHKtxsg1n0=";
      type = "gem";
    };
    version = "3.3.0";
  };
  database_cleaner-active_record = {
    dependencies = [
      "activerecord"
      "database_cleaner-core"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-MijW2OwfIQP9arRo2ukjQkMYvPq89d1bAuX8sMSG4cc=";
      type = "gem";
    };
    version = "2.2.0";
  };
  database_cleaner-core = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hkZXTDIWLlnte1JYqXogjTxEVRuFTlEJlPJGg4ZdhGw=";
      type = "gem";
    };
    version = "2.0.1";
  };
  date = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vyaOFO9xWACb/q7EC1+jxycZBuiLGW2VionUtAir5k8=";
      type = "gem";
    };
    version = "3.4.1";
  };
  debug = {
    dependencies = [
      "irb"
      "reline"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SOAmwIUsehDGAmPi5SeWgwiVjiZiMeNtZOPvyr7H5/w=";
      type = "gem";
    };
    version = "1.9.2";
  };
  debug_inspector = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-m9+gLuvD2hY4M+aomxVAhCMvV2YIfllXO3BSHHfqaKI=";
      type = "gem";
    };
    version = "1.2.0";
  };
  devise = {
    dependencies = [
      "bcrypt"
      "orm_adapter"
      "railties"
      "responders"
      "warden"
    ];
    groups = [
      "default"
      "pam_authentication"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kgBC/l5wTFSKpOtl691lmAuD/65n/rMsaXIGv9l1p/g=";
      type = "gem";
    };
    version = "4.9.4";
  };
  devise-two-factor = {
    dependencies = [
      "activesupport"
      "devise"
      "railties"
      "rotp"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6MLSy2MYtIbTij78TVdK7hkrcYuSxu8TtvzrpFD1pvs=";
      type = "gem";
    };
    version = "6.0.0";
  };
  devise_pam_authenticatable2 = {
    dependencies = [
      "devise"
      "rpam2"
    ];
    groups = [ "pam_authentication" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4h7krCE94B5dWGO6JeI6QwSwedxhKIZu34bBeUWhN44=";
      type = "gem";
    };
    version = "9.2.0";
  };
  diff-lcs = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JzIj37QGhVSENtMrRzOqZzUXacfepiHafZ3UgT5j3f4=";
      type = "gem";
    };
    version = "1.5.1";
  };
  discard = {
    dependencies = [ "activerecord" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-VSGJl8pNwR8FlPG7LRGWxKlZzrVi8atkkBMCM1mN2mc=";
      type = "gem";
    };
    version = "1.3.0";
  };
  docile = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lhWb55m/pzzbchuEDpgCEm5OA9/CaGPbc2RyBMcn8h4=";
      type = "gem";
    };
    version = "1.4.1";
  };
  domain_name = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-X2k7IhVwhHZRdHm/KzgC5JBorYIWe80ihviZU2oX2TM=";
      type = "gem";
    };
    version = "0.6.20240107";
  };
  doorkeeper = {
    dependencies = [ "railties" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-iwj1lGxiUFvhoy+QlOuZ7KMrKA6Vb1FVKeM7KwJb1ig=";
      type = "gem";
    };
    version = "5.7.1";
  };
  dotenv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bcUC5xjqDTVCZzNF2gXHppA5hAiY4lF1ets0BdKzVik=";
      type = "gem";
    };
    version = "3.1.4";
  };
  drb = {
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6dRyv3hfVYuWslNYuuEVZG2g2/1FEHrYWLC8DZNcs0A=";
      type = "gem";
    };
    version = "2.2.1";
  };
  elasticsearch = {
    dependencies = [
      "elasticsearch-api"
      "elasticsearch-transport"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7QgPCF2TnyHQf0JOvOqVMm5L2193Co8zqsaZN08v/IY=";
      type = "gem";
    };
    version = "7.17.11";
  };
  elasticsearch-api = {
    dependencies = [ "multi_json" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/tj3tkSTyXzzmEozOWp5ggS1S44bAcW2wJn6P9QgkQc=";
      type = "gem";
    };
    version = "7.17.11";
  };
  elasticsearch-dsl = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-03VuQJFuMzjLuxvVkjRRWx0s6cZ1dfHkXFzVUbkblZw=";
      type = "gem";
    };
    version = "0.1.10";
  };
  elasticsearch-transport = {
    dependencies = [
      "base64"
      "faraday"
      "multi_json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0YBX1SleTDn+gAhO3p4A6cDg10WANImF+Gd7L7f3DwM=";
      type = "gem";
    };
    version = "7.17.11";
  };
  email_spec = {
    dependencies = [
      "htmlentities"
      "launchy"
      "mail"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3yO+ehMRhvej1b47NeqskZb5rBO9JsnD1ZNB4T2FLRE=";
      type = "gem";
    };
    version = "2.3.0";
  };
  erubi = {
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/KYbR9rv2GXQ+1DRaGNPJ61AGBhnRFut9kJ8RZwzzWI=";
      type = "gem";
    };
    version = "1.13.0";
  };
  et-orbi = {
    dependencies = [ "tzinfo" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0m6GjMIduIKAqewaUKo9pdJn65sgN7p7gx1sJzH132Q=";
      type = "gem";
    };
    version = "1.2.11";
  };
  excon = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kOAXGUpeh5RrcGJzZ3/+i0GCQfQREa2LSZuNNkQwiio=";
      type = "gem";
    };
    version = "0.111.0";
  };
  fabrication = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LHnxDRuIA0ouvUfOd6y6ZoR/xGNlgcgoKzQIrcaOhao=";
      type = "gem";
    };
    version = "2.31.0";
  };
  faker = {
    dependencies = [ "i18n" ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UWtaNCAg5ihrBhCE16YMhIwCTpyR99tvlL9bq0XvQPY=";
      type = "gem";
    };
    version = "3.4.2";
  };
  faraday = {
    dependencies = [
      "faraday-em_http"
      "faraday-em_synchrony"
      "faraday-excon"
      "faraday-httpclient"
      "faraday-multipart"
      "faraday-net_http"
      "faraday-net_http_persistent"
      "faraday-patron"
      "faraday-rack"
      "faraday-retry"
      "ruby2_keywords"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IPUun3MjHl89Q/tkWQFXPOK3XwvQHqUqJ3ITPQEG5rA=";
      type = "gem";
    };
    version = "1.10.3";
  };
  faraday-em_http = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ej1McHl4kSEFT1fgjNTvfkCtFUm2MQHzjHCTqdbFlok=";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-em_synchrony = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Rg2tHDDMaS1ud9TDkcyttOykhUsxVjLNflYPdCdc+e0=";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-excon = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-sFXIQjdnNNf3Q1D+hhFUKuIADFOHNI2bqXCBCdbkCUA=";
      type = "gem";
    };
    version = "1.1.0";
  };
  faraday-httpclient = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TI/x8Jc/+DW+jQQ+8WqvVPR/JbdXj22Rbe7oOZoE0zs=";
      type = "gem";
    };
    version = "1.0.1";
  };
  faraday-multipart = {
    dependencies = [ "multipart-post" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kBICGrV3kPfXEvWQtI1flIsZtDz6EcqD5kWfBgkLByU=";
      type = "gem";
    };
    version = "1.0.4";
  };
  faraday-net_http = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Y5ku/qQskloggYzzwIMJR5SFQf3PNFhCdVUQ0mbkxoI=";
      type = "gem";
    };
    version = "1.0.2";
  };
  faraday-net_http_persistent = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Cwy8jwPauUPD4cxY2Le+sULZ3waLOccYzYPjkmA0gzU=";
      type = "gem";
    };
    version = "1.2.0";
  };
  faraday-patron = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3CzXs0C7PMjja8uebn7/Q9E0ttUm1fNCnHp2gN3Tj6c=";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-rack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-72DslporuVuNvyRAAVWu5koA/IumxqTTloVivMkjKMA=";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-retry = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-rdFU9POZJDy+BwgG7UG5aQaULn9SWbsf5try7I9JcZQ=";
      type = "gem";
    };
    version = "1.0.3";
  };
  faraday_middleware = {
    dependencies = [ "faraday" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3tFdV01Q6SvQREjVVmkTr1yxoBsvoxHO7MJGT6CriK8=";
      type = "gem";
    };
    version = "1.2.0";
  };
  fast_blank = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Jp/DBBT+1OZAO8SkkIHh6lOfi5Im5ZJ27R7676uqF+o=";
      type = "gem";
    };
    version = "1.0.1";
  };
  fastimage = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-I8Yp8fPn1hvPzAbCWz0kGLxr9B0uYV2/UTLA47Y+zOk=";
      type = "gem";
    };
    version = "2.3.1";
  };
  ffi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Jvaw29EQHm/8CdPKZAsqIYQMxScxrYp97Z+4nl+w/Dk=";
      type = "gem";
    };
    version = "1.17.1";
  };
  ffi-compiler = {
    dependencies = [
      "ffi"
      "rake"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qU89gdEsr1xdTs8TmApw0K6qciaPO5zBM1i8xlCRhKA=";
      type = "gem";
    };
    version = "1.3.2";
  };
  flatware = {
    dependencies = [
      "drb"
      "thor"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-M0ZPxD+3uuTLE+RHh/W33GNRXzpigKzCZmfF0v+l1Bs=";
      type = "gem";
    };
    version = "2.3.4";
  };
  flatware-rspec = {
    dependencies = [
      "flatware"
      "rspec"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-y6Y6bqaDpCSa90mYBnezlC55r1xu9AwQxqYtrGiUE78=";
      type = "gem";
    };
    version = "2.3.4";
  };
  fog-core = {
    dependencies = [
      "builder"
      "excon"
      "formatador"
      "mime-types"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tHuAZHpuWBdFXsK6qPXKXj9DHZUY6HbVUzDQi0UMwu0=";
      type = "gem";
    };
    version = "2.5.0";
  };
  fog-json = {
    dependencies = [
      "fog-core"
      "multi_json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3U9as2LbxytockC7qdLdhB1d/oiKKFeXUz+FwD6lSP4=";
      type = "gem";
    };
    version = "1.2.0";
  };
  fog-openstack = {
    dependencies = [
      "fog-core"
      "fog-json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uMFNi5/ZYO577twhg9/TU6Po3f26xJ3nv76slaga8/w=";
      type = "gem";
    };
    version = "1.1.3";
  };
  formatador = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-VOI+KvTWC7kyfH+sYrKZaOTPKM7gER9ybQvercheBtA=";
      type = "gem";
    };
    version = "1.1.0";
  };
  fugit = {
    dependencies = [
      "et-orbi"
      "raabro"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6JSF574iIm2OnG2kEWZNBmAoS0scCMrLVA9QWQeGmGg=";
      type = "gem";
    };
    version = "1.11.1";
  };
  globalid = {
    dependencies = [ "activesupport" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cL92cRhx+EPbunK+uGEyKaSUKdGGaChHb5ydbMwyfOk=";
      type = "gem";
    };
    version = "1.2.1";
  };
  google-protobuf = {
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QzP+LpAJEx2L7JtP/PrntaCi0b0YBh6KqvD9PVyDVjk=";
      type = "gem";
    };
    version = "3.25.5";
  };
  googleapis-common-protos-types = {
    dependencies = [ "google-protobuf" ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-V7FgDCcfozEgluVaMEDSDSwPml1l0P3h8W5c2ZurFWs=";
      type = "gem";
    };
    version = "1.15.0";
  };
  haml = {
    dependencies = [
      "temple"
      "thor"
      "tilt"
    ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jm64fYaWOeNIhSAJ50oqFmPXlmPtfn28s4vrHxK83Zc=";
      type = "gem";
    };
    version = "6.3.0";
  };
  haml-rails = {
    dependencies = [
      "actionpack"
      "activesupport"
      "haml"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JzugGJ4vgs5LI4UBndkTiIQBfjEDzC6uvu5/RRhvWeo=";
      type = "gem";
    };
    version = "2.1.0";
  };
  haml_lint = {
    dependencies = [
      "haml"
      "parallel"
      "rainbow"
      "rubocop"
      "sysexits"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-L3loZHeaIT1tA3ySOoBjMn4L0llx8euBRSaZ2WUjwtU=";
      type = "gem";
    };
    version = "0.58.0";
  };
  hashdiff = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-x5ZjFnJuDO7+n1xq7xB+vDzP74tttV/jk08Eayzwk2o=";
      type = "gem";
    };
    version = "1.1.1";
  };
  hashie = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nWxOUfKjbUYWy8ijItYZoWLY9CgVp5JZYDn8lVlWA9o=";
      type = "gem";
    };
    version = "5.0.0";
  };
  hcaptcha = {
    dependencies = [ "json" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oqKEMRdfMw34+wuplmSYW4UJzqr+CYn/nlFs+kMaBjo=";
      type = "gem";
    };
    version = "7.1.0";
  };
  highline = {
    dependencies = [ "reline" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eoJIfjXgV84zVaB2fGfQ3HdQrzZH0DfS1YKU6H48DuA=";
      type = "gem";
    };
    version = "3.1.1";
  };
  hiredis = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-fwUuMg99JLXCqf32fG/2+s324lY5SnA1EbzjTs9EUhI=";
      type = "gem";
    };
    version = "0.6.3";
  };
  hkdf = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NMYsdwhFGqzLuv3mLEcdg3qhdNwwMCOB38SGosDr0RE=";
      type = "gem";
    };
    version = "0.3.0";
  };
  htmlentities = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Elpzxsny0bYhALfDxAHjYkRBtmN2Kvp/5ChHZDWmc9o=";
      type = "gem";
    };
    version = "4.3.4";
  };
  http = {
    dependencies = [
      "addressable"
      "base64"
      "http-cookie"
      "http-form_data"
      "llhttp-ffi"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uZ7TxlN24P2BB2R/uvWoq09mw0fRJx+3TOp1fiCcYRU=";
      type = "gem";
    };
    version = "5.2.0";
  };
  http-cookie = {
    dependencies = [ "domain_name" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-c3VtRsfb3HAj3uzbihcTSOqVobmYELMc/otPtOmmMY8=";
      type = "gem";
    };
    version = "1.0.5";
  };
  http-form_data = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zE7rE2HZh2gh4x17HPC2jxz4dLIB0nkDSAR52GRIpfM=";
      type = "gem";
    };
    version = "2.3.0";
  };
  http_accept_language = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-AEPw1VoUjPRbYE290ZfLNkNxM+mQAWxoyJLUnb6jFjQ=";
      type = "gem";
    };
    version = "2.1.1";
  };
  httpclient = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KVHkmRIURkw+khB+RkOFJ9IwSOY0867pHHGeC9+uvaY=";
      type = "gem";
    };
    version = "2.8.3";
  };
  httplog = {
    dependencies = [
      "rack"
      "rainbow"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-iSyVmIiWHLHhY/A/CeNLkS76+jwBiuJiqqv5WF0jFiU=";
      type = "gem";
    };
    version = "1.7.0";
  };
  i18n = {
    dependencies = [ "concurrent-ruby" ];
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3CKadPXRgfCZQt1gq11uZn9zksTugm81CW2zbR/jYUw=";
      type = "gem";
    };
    version = "1.14.6";
  };
  i18n-tasks = {
    dependencies = [
      "activesupport"
      "ast"
      "erubi"
      "highline"
      "i18n"
      "parser"
      "rails-i18n"
      "rainbow"
      "terminal-table"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Otja7yoyaNbcIjKq0rEpQbNT2ITNMP07QYpz5wAaA+w=";
      type = "gem";
    };
    version = "1.0.14";
  };
  idn-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-MHb6GqwXDpIxDQKCK632sR504XkVoEXI+a0FO7okwDc=";
      type = "gem";
    };
    version = "0.1.5";
  };
  inline_svg = {
    dependencies = [
      "activesupport"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-W2UpNCNv2fitxh8/1uIIt8oygmmLGfKGWZcdqEv5oQ8=";
      type = "gem";
    };
    version = "1.10.0";
  };
  io-console = {
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8NzP8lL4d6T2DQSk3GtEKxhev/tLMgq2khKpK0inoiE=";
      type = "gem";
    };
    version = "0.7.2";
  };
  irb = {
    dependencies = [
      "rdoc"
      "reline"
    ];
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WXUAO1jTbvr0kjgLqpgs7t9a7TaWek1bQJlrxcZugPg=";
      type = "gem";
    };
    version = "1.14.1";
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
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GJi1y8gc02wP1NC3rSaCw5+wfF/2gvxiZfZ49VDUmCw=";
      type = "gem";
    };
    version = "2.7.2";
  };
  json-canonicalization = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1ISKjMp1NEVcZyHy2fyeXprcpJSGhkqJiBACT2fVlEY=";
      type = "gem";
    };
    version = "1.0.0";
  };
  json-jwt = {
    dependencies = [
      "activesupport"
      "aes_key_wrap"
      "bindata"
      "httpclient"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-krJzeCEraqcqupOlN+q9f3rHrTjhK2OIY813J+DcsI8=";
      type = "gem";
    };
    version = "1.15.3.1";
  };
  json-ld = {
    dependencies = [
      "htmlentities"
      "json-canonicalization"
      "link_header"
      "multi_json"
      "rack"
      "rdf"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uVMYk79b3AHbQo6WlThFojrbEJcSXOkYrg+XxKbhqyc=";
      type = "gem";
    };
    version = "3.3.2";
  };
  json-ld-preloaded = {
    dependencies = [
      "json-ld"
      "rdf"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gQknRNxrglt++ENXoqqKjuzrCqdCMNDexLUXgu6NSLg=";
      type = "gem";
    };
    version = "3.3.0";
  };
  json-schema = {
    dependencies = [ "addressable" ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-72w+wTtERhyP/5dDN2U/dS6pG+5N8a9d0O2sdgWYwHo=";
      type = "gem";
    };
    version = "5.0.0";
  };
  jsonapi-renderer = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tcRLAz1htKvbZQD6SrhIB8oLNuoOWeR6LDynCVpuRHs=";
      type = "gem";
    };
    version = "0.2.2";
  };
  jwt = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BzV80vGAc5svgYTtqWniUthQrJlu0KI/YW6P8KkK4Zs=";
      type = "gem";
    };
    version = "2.7.1";
  };
  kaminari = {
    dependencies = [
      "activesupport"
      "kaminari-actionview"
      "kaminari-activerecord"
      "kaminari-core"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xAdv+a3MxhCUCDM/h7XEq72l453EZL1MZtBtn3NEKj4=";
      type = "gem";
    };
    version = "1.2.2";
  };
  kaminari-actionview = {
    dependencies = [
      "actionview"
      "kaminari-core"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EzD2/ItZpKTvalSf+KIkeXKJ6/ejpQPowWUlNSh8yQk=";
      type = "gem";
    };
    version = "1.2.2";
  };
  kaminari-activerecord = {
    dependencies = [
      "activerecord"
      "kaminari-core"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DdOme6s1ajVvNrO3I2vLgc7zEwlTZb7+jpgFfdJHJDA=";
      type = "gem";
    };
    version = "1.2.2";
  };
  kaminari-core = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-O9Jv7HNwZFr0DKc7lCakSNCbiounr6m6PD4NOc27g/8=";
      type = "gem";
    };
    version = "1.2.2";
  };
  kt-paperclip = {
    dependencies = [
      "activemodel"
      "activesupport"
      "marcel"
      "mime-types"
      "terrapin"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lbAjs2dI9eRFH6TkURqIpRvIYDTtN/iIp5OsfMoBH8k=";
      type = "gem";
    };
    version = "7.2.2";
  };
  language_server-protocol = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PVxYwC9Eog2XKVep/r44bX50aKs5AM5r0rVj3ZEMaz8=";
      type = "gem";
    };
    version = "3.17.0.3";
  };
  launchy = {
    dependencies = [
      "addressable"
      "childprocess"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-t/pgvaAZfPV2FOJxolCoyh9qNKuImjxz9n7F1XyKfyw=";
      type = "gem";
    };
    version = "3.0.1";
  };
  letter_opener = {
    dependencies = [ "launchy" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-L/M/LjtcPCbRlZvlSzlcCGym1Egm6L9BoU/5b98b27I=";
      type = "gem";
    };
    version = "1.10.0";
  };
  letter_opener_web = {
    dependencies = [
      "actionmailer"
      "letter_opener"
      "railties"
      "rexml"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Pzke/g6LmyS+z6tVN9+xelz161MgOPlH2qtYy0t0mGA=";
      type = "gem";
    };
    version = "3.0.0";
  };
  link_header = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-FcZc5Dsp9zmzDQXl8lwiwjeX6Jz2+QXbtZX7THDLVfk=";
      type = "gem";
    };
    version = "0.0.8";
  };
  llhttp-ffi = {
    dependencies = [
      "ffi-compiler"
      "rake"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SW9ArUS8v5neAtofJrGtZOZZPNSHuTFQioYijio68Po=";
      type = "gem";
    };
    version = "0.5.0";
  };
  logger = {
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3WGNJOY3cVRycy5+7QLjPPvfVt6q0iXt0PH4nTgCQBc=";
      type = "gem";
    };
    version = "1.6.6";
  };
  lograge = {
    dependencies = [
      "actionpack"
      "activesupport"
      "railties"
      "request_store"
    ];
    groups = [ "production" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QjcadYI3dfFm9ydjn13c5z3RSUUqVfyUuQwwMhPcmuE=";
      type = "gem";
    };
    version = "0.14.0";
  };
  loofah = {
    dependencies = [
      "crass"
      "nokogiri"
    ];
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ENduBwyGsS/sdLapUV/RlA9EWRmLmRNC0KeJfYbDcv4=";
      type = "gem";
    };
    version = "2.22.0";
  };
  mail = {
    dependencies = [
      "mini_mime"
      "net-imap"
      "net-pop"
      "net-smtp"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7Dufrc8rN1XHh4XLF7yaDKnumFcQimS29c/JwLW/ya0=";
      type = "gem";
    };
    version = "2.8.1";
  };
  marcel = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DVZJ/rZLjxnz00aLlsaAuul0YzXQIZQnAoeGimYVFqQ=";
      type = "gem";
    };
    version = "1.0.4";
  };
  mario-redis-lock = {
    dependencies = [ "redis" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JzB+KhYSCzw+XjByB+KNVSBOVlHk9her0PZ+LJlsPO0=";
      type = "gem";
    };
    version = "1.2.1";
  };
  matrix = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cQg8y9Z6FKQ7+njT5NwPS1A7nMGOW0sdaG3A+e98TMA=";
      type = "gem";
    };
    version = "0.4.2";
  };
  md-paperclip-azure = {
    dependencies = [
      "addressable"
      "azure-storage-blob"
      "hashie"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hQL7obWYBJputbBdljXwkWSkoCFOlnAozB/F0Q1QYcE=";
      type = "gem";
    };
    version = "2.2.0";
  };
  memory_profiler = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eaF995gKFAyDxGl4WQVAnTAnymFMQsCGCJ0Si4BaqPg=";
      type = "gem";
    };
    version = "1.1.0";
  };
  mime-types = {
    dependencies = [ "mime-types-data" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-wSmfEPo0x1pvFo6Z6drb0RvFB9nWLcXPmMTmXyr4xOQ=";
      type = "gem";
    };
    version = "3.5.2";
  };
  mime-types-data = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uv1xooHFGezKnBdUDtNMPqtWlmT5581zT/xN9I35r+0=";
      type = "gem";
    };
    version = "3.2024.0820";
  };
  mini_mime = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hoG34uQhXyoVn5QAtYFthenYxsa0kelqEnl+eY+LzO8=";
      type = "gem";
    };
    version = "1.1.5";
  };
  mini_portile2 = {
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jkcTbNrATOgXULtsCXM7N4lb8GliVU5LQFbXgWjXCnU=";
      type = "gem";
    };
    version = "2.8.8";
  };
  minitest = {
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PbZ5WoBjTe8c+G/aedLYO1myXOXhhvpnX3PFZVidKtg=";
      type = "gem";
    };
    version = "5.25.1";
  };
  msgpack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Wati/YpNDfveRQCfh+tvFYqyYop8SIhrAlbxdRZrqqg=";
      type = "gem";
    };
    version = "1.7.2";
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
  multipart-post = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mHLQOo5VICDKCWra2/XjyxzRzdas08FhE2uKVzfNtKg=";
      type = "gem";
    };
    version = "2.4.1";
  };
  mutex_m = {
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tu8MbIQu3oRvLsCt6eJmsanawLwVFoKwSDXo69VIQNU=";
      type = "gem";
    };
    version = "0.2.0";
  };
  net-http = {
    dependencies = [ "uri" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qW78XqGLy5cV4k3aQVnRD2f/A0XIqYDQRjACgFWywoI=";
      type = "gem";
    };
    version = "0.4.1";
  };
  net-http-persistent = {
    dependencies = [ "connection_pool" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-A/gnozhXsdVrTnlpV60Zv1tYNn2FP9CiJOtw+6jQKkQ=";
      type = "gem";
    };
    version = "4.0.2";
  };
  net-imap = {
    dependencies = [
      "date"
      "net-protocol"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Uqpf38Goo98feTsgoyfpW1qd/h1zPh8NUwddLbz89ZM=";
      type = "gem";
    };
    version = "0.5.8";
  };
  net-ldap = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vio3nMvSj8dftwqUr3TjqaaGa4RXQkf8JD4KvdL4Lz0=";
      type = "gem";
    };
    version = "0.19.0";
  };
  net-pop = {
    dependencies = [ "net-protocol" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hItOmCATwVsvA4J5Imh2O3SMzpHJ6R42sPJ+0mQg3/M=";
      type = "gem";
    };
    version = "0.1.2";
  };
  net-protocol = {
    dependencies = [ "timeout" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qnPgy6ahJTad6YN7jY74KmGEk2DroFIZAOLDcTqhYqg=";
      type = "gem";
    };
    version = "0.2.2";
  };
  net-smtp = {
    dependencies = [ "net-protocol" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7Zagr2PFJPzrSymw01IZXDDYLdkWpC8Dxio6cOW3BzY=";
      type = "gem";
    };
    version = "0.5.1";
  };
  nio4r = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-VLlM3UuPncOaqtX2mel6+uE++0TysYCm5yTfdhBf9gQ=";
      type = "gem";
    };
    version = "2.7.3";
  };
  nokogiri = {
    dependencies = [
      "mini_portile2"
      "racc"
    ];
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jHRkh12cp/cQgMJMDbe8qjlA6L48b8S868z4uaABY2U=";
      type = "gem";
    };
    version = "1.18.8";
  };
  oj = {
    dependencies = [
      "bigdecimal"
      "ostruct"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/RMrJmhvPCyNxmn3Bm2lvcHHczRKL2v/V8LVY8GaWsw=";
      type = "gem";
    };
    version = "3.16.6";
  };
  omniauth = {
    dependencies = [
      "hashie"
      "rack"
      "rack-protection"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jSTi5VxBkmyW5Kk/1Wa8Am39byyFBAh0jomUWlZZVsI=";
      type = "gem";
    };
    version = "2.1.3";
  };
  omniauth-cas = {
    dependencies = [
      "addressable"
      "nokogiri"
      "omniauth"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-etFp2AZqWKzq3h37jxX7WcKtmi9kglUaqVq3WZtB5o8=";
      type = "gem";
    };
    version = "3.0.0";
  };
  omniauth-rails_csrf_protection = {
    dependencies = [
      "actionpack"
      "omniauth"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EXD9Zyr/CSubfr68FFNVnwc+0AHjzmKh32FuMvjcX+A=";
      type = "gem";
    };
    version = "1.0.2";
  };
  omniauth-saml = {
    dependencies = [
      "omniauth"
      "ruby-saml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1ODb3LME5Lt0QQ63XeqhhzsIpCr6djTJwxcb4LNHUbA=";
      type = "gem";
    };
    version = "2.2.3";
  };
  omniauth_openid_connect = {
    dependencies = [
      "omniauth"
      "openid_connect"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XxMY9bGbBeM5/0lN7wYLV6UDsePqg8OgztbMAUQH1CM=";
      type = "gem";
    };
    version = "0.6.1";
  };
  openid_connect = {
    dependencies = [
      "activemodel"
      "attr_required"
      "json-jwt"
      "net-smtp"
      "rack-oauth2"
      "swd"
      "tzinfo"
      "validate_email"
      "validate_url"
      "webfinger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-iH2rcwnVWby+WokTCoWUD53R4HeF2tw+3GYXcndsM80=";
      type = "gem";
    };
    version = "1.4.2";
  };
  openssl = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PEu4dgl3tL7NKBnGwlabz1xvSLMrn3pM4f03+ZY3jRQ=";
      type = "gem";
    };
    version = "3.2.0";
  };
  openssl-signature_algorithm = {
    dependencies = [ "openssl" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-o7QLXoJ2Fi1KblDHyXza8URvmyw5Rqb6LBRijgyVfoA=";
      type = "gem";
    };
    version = "1.3.0";
  };
  opentelemetry-api = {
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pzPe5NVsIUDpRutbqZmTV11Olt2X4HrJSII68DtmQDY=";
      type = "gem";
    };
    version = "1.4.0";
  };
  opentelemetry-common = {
    dependencies = [ "opentelemetry-api" ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/okaRFg6ILwyF7MkrsdtBmUESUlRaC05HP1X1AzQHJg=";
      type = "gem";
    };
    version = "0.21.0";
  };
  opentelemetry-exporter-otlp = {
    dependencies = [
      "google-protobuf"
      "googleapis-common-protos-types"
      "opentelemetry-api"
      "opentelemetry-common"
      "opentelemetry-sdk"
      "opentelemetry-semantic_conventions"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TRyg4ByrgSfcxD6ztRhF384rly1RAz33zjOtvcMGgfo=";
      type = "gem";
    };
    version = "0.29.0";
  };
  opentelemetry-helpers-sql-obfuscation = {
    dependencies = [ "opentelemetry-common" ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-31Z0jvdMZIfMEnVmWcbamE13vFKy/JiedJay+eiwhGw=";
      type = "gem";
    };
    version = "0.2.0";
  };
  opentelemetry-instrumentation-action_mailer = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-active_support"
      "opentelemetry-instrumentation-base"
    ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Uv40ALuQUdB5oq7QhY/C2Yxne/tm0WPjtDi2fHld0ak=";
      type = "gem";
    };
    version = "0.1.0";
  };
  opentelemetry-instrumentation-action_pack = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
      "opentelemetry-instrumentation-rack"
    ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xd+Ecq/Jzb/BQl2a94FrnPwaGmm4ZiHx/GJJdL2ay5o=";
      type = "gem";
    };
    version = "0.9.0";
  };
  opentelemetry-instrumentation-action_view = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-active_support"
      "opentelemetry-instrumentation-base"
    ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-MPLaFUev144hk/FuHPbVPZoGZQoawptL2i8bLUGjEZ8=";
      type = "gem";
    };
    version = "0.7.2";
  };
  opentelemetry-instrumentation-active_job = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XbiCCv1D5E04NwXAkZJJ8RCC9EcslsNB/Be4lUZ3qqg=";
      type = "gem";
    };
    version = "0.7.7";
  };
  opentelemetry-instrumentation-active_model_serializers = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-x4JuibeWQrwB/1vZLkJcm1xkWBMzonu0RYxM85FDiXs=";
      type = "gem";
    };
    version = "0.20.2";
  };
  opentelemetry-instrumentation-active_record = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7zLscB0PpsqlcWaR/bRQJ213xxQm5RsbZ15FUwpIJm8=";
      type = "gem";
    };
    version = "0.7.3";
  };
  opentelemetry-instrumentation-active_support = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-T+ceK+IRNcSm64CGmYxQje7FAICQCCn7aV7gG5O1B+A=";
      type = "gem";
    };
    version = "0.6.0";
  };
  opentelemetry-instrumentation-base = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-common"
      "opentelemetry-registry"
    ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PuVhCbTVxWPvlc8axATc6Zyc3JektBn8dGCe+CK+Ul8=";
      type = "gem";
    };
    version = "0.22.6";
  };
  opentelemetry-instrumentation-concurrent_ruby = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BO/IEURZu9XRBLVZxBOu9C4SoaSJ5B3yt7iesfiHFM4=";
      type = "gem";
    };
    version = "0.21.4";
  };
  opentelemetry-instrumentation-excon = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2jKf2iVMZ40Ht5uj2pSaY5s0+3uGi7xw2unPMOZu5pE=";
      type = "gem";
    };
    version = "0.22.4";
  };
  opentelemetry-instrumentation-faraday = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UEsM9NcNKcShOpn7QIrRog8vtyvJZMarcU0EO5nl5lo=";
      type = "gem";
    };
    version = "0.24.6";
  };
  opentelemetry-instrumentation-http = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GQtAG0onWPwc4g+gc/EE5owxUmYeBXafWqlcXdGjuRY=";
      type = "gem";
    };
    version = "0.23.4";
  };
  opentelemetry-instrumentation-http_client = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-P9yoWiAKDoty8Cz7f2CQYvx5M1Omwv/uLajgBfYvzjw=";
      type = "gem";
    };
    version = "0.22.7";
  };
  opentelemetry-instrumentation-net_http = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-wHQn/2t77RJL8AQAi+TTpK74hlYp96LEYUxKjTVyRtA=";
      type = "gem";
    };
    version = "0.22.7";
  };
  opentelemetry-instrumentation-pg = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-helpers-sql-obfuscation"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-b8vd37dX/tl7O84PufXyBtTNtcJOPaeMDcVBAMGV89E=";
      type = "gem";
    };
    version = "0.29.0";
  };
  opentelemetry-instrumentation-rack = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-wPJ73I1Ae7TZfq0ntu5yJDuG8y96anA/UVj8LhjrrrY=";
      type = "gem";
    };
    version = "0.24.6";
  };
  opentelemetry-instrumentation-rails = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-action_mailer"
      "opentelemetry-instrumentation-action_pack"
      "opentelemetry-instrumentation-action_view"
      "opentelemetry-instrumentation-active_job"
      "opentelemetry-instrumentation-active_record"
      "opentelemetry-instrumentation-active_support"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-iR8g4xI7Dql/ft5gwqVBUZHFtF9jeOvwOkUonmbQZIo=";
      type = "gem";
    };
    version = "0.31.2";
  };
  opentelemetry-instrumentation-redis = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LqDy1F/hrwaJrq3Aj1szWittlGPenYVf0lMT08W0L+M=";
      type = "gem";
    };
    version = "0.25.7";
  };
  opentelemetry-instrumentation-sidekiq = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-instrumentation-base"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1qbiyt3f2goLZB+dyRjjWne/xivJC4B3b1GUvVXg3zE=";
      type = "gem";
    };
    version = "0.25.7";
  };
  opentelemetry-registry = {
    dependencies = [ "opentelemetry-api" ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-c6SCNGNbDtHHXktfsmf7MAS69hbUP+OOg4Dsu5M9iN8=";
      type = "gem";
    };
    version = "0.3.1";
  };
  opentelemetry-sdk = {
    dependencies = [
      "opentelemetry-api"
      "opentelemetry-common"
      "opentelemetry-registry"
      "opentelemetry-semantic_conventions"
    ];
    groups = [ "opentelemetry" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2hAnwN71kXyEZ6wfNpK2DAVO6RrrNu4SDf0wxYs9OzY=";
      type = "gem";
    };
    version = "1.5.0";
  };
  opentelemetry-semantic_conventions = {
    dependencies = [ "opentelemetry-api" ];
    groups = [
      "default"
      "opentelemetry"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/pz4I6hGy7uwMAy1oJDEBytXsu0hrI24LehdMw7vVoE=";
      type = "gem";
    };
    version = "1.10.1";
  };
  orm_adapter = {
    groups = [
      "default"
      "pam_authentication"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ql0L5dVAy7RtOpPogGH07OaiX26X1qRxIr64T+WV6bk=";
      type = "gem";
    };
    version = "0.5.0";
  };
  ostruct = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Oxc2yZ9NmF3ja94RVb5eIqr25WSzD/m9SB4u98LZuoU=";
      type = "gem";
    };
    version = "0.6.0";
  };
  ox = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mT4CkEkbq2u9SUbS+phxGwUmNLuyXXgSuTGyneVWL3E=";
      type = "gem";
    };
    version = "2.14.18";
  };
  parallel = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2Gurt6K4FL6fS4FYe/C2zi2n1Flp+rJNiuS/K7TUx+8=";
      type = "gem";
    };
    version = "1.26.3";
  };
  parser = {
    dependencies = [
      "ast"
      "racc"
    ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8w67cbeDDC583EsrDg7CI0kA4/yj/i+6R/eL51kYGrM=";
      type = "gem";
    };
    version = "3.3.5.0";
  };
  parslet = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1FEwaV05tD1+apH00uxms4io2CK6443ptN6aX73h9gY=";
      type = "gem";
    };
    version = "2.0.0";
  };
  pastel = {
    dependencies = [ "tty-color" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SB2p+30vbmsaCPrxH6EDYxctxA/UeEjwlq4hIJ+AWnU=";
      type = "gem";
    };
    version = "0.8.0";
  };
  pg = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-79cZOd0dbZ8LQ03GHe5u9k8dK/zTwXdZioeXwn5lTzc=";
      type = "gem";
    };
    version = "1.5.8";
  };
  pghero = {
    dependencies = [ "activerecord" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ytnLhl+Z/0C7W6R9Pa4g0GvgasjqawEXL2qMzIVnEQk=";
      type = "gem";
    };
    version = "3.6.0";
  };
  premailer = {
    dependencies = [
      "addressable"
      "css_parser"
      "htmlentities"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-D+I0jNgnOIVcSCsxyRWgbssdOtAEV4wZBCkFGW3b0ec=";
      type = "gem";
    };
    version = "1.27.0";
  };
  premailer-rails = {
    dependencies = [
      "actionmailer"
      "net-smtp"
      "premailer"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-wTgV0WG5vH99PYE5awuwphqQ+pvYmTFUi/TlN8dxBAA=";
      type = "gem";
    };
    version = "1.12.0";
  };
  propshaft = {
    dependencies = [
      "actionpack"
      "activesupport"
      "rack"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-04k2H69mrrF+jSBIKJYsHlBu3RShoXrbP6R1Q1wHD2s=";
      type = "gem";
    };
    version = "1.1.0";
  };
  psych = {
    dependencies = [ "stringio" ];
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-M3Mi9Y/CvySCfSub1atZX2pylxhn0VG7OZgAYOpAo2g=";
      type = "gem";
    };
    version = "5.1.2";
  };
  public_suffix = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YdROHKtcu75bMQaEgc8Wl23Q3BtrB72VYX74xePgDG8=";
      type = "gem";
    };
    version = "6.0.1";
  };
  puma = {
    dependencies = [ "nio4r" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JKRkXABoEdg/JIAFfR9UqW52J7a5DhyZsmC53GMOtD4=";
      type = "gem";
    };
    version = "6.4.3";
  };
  pundit = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Q+bSep3wgsBPACCZnOTc9nQuzFd10QLvK/6d8EFBdXI=";
      type = "gem";
    };
    version = "2.4.0";
  };
  raabro = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1Pqf9Rcjke25KyQu7YvoAtGTSxRkBhrl5w2AlixdqII=";
      type = "gem";
    };
    version = "1.4.0";
  };
  racc = {
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Sn9pKWkdvsi1IJoLNzvCYUiCtV/F0uRHohqqaRMD1i8=";
      type = "gem";
    };
    version = "1.8.1";
  };
  rack = {
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zO4QFxlpal2hLunab7Ox0gyzKZOeCJ4ORYvm6TZn8Ps=";
      type = "gem";
    };
    version = "2.2.13";
  };
  rack-attack = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PKR+j2bNM7LJavU+pHVFJc2SjtP6jaEO5trQJ3eR13w=";
      type = "gem";
    };
    version = "6.7.0";
  };
  rack-cors = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QV1OFZmJF2DF3J7wNJx/7N+U98agPnWy58K1S4Kt2hs=";
      type = "gem";
    };
    version = "2.0.2";
  };
  rack-oauth2 = {
    dependencies = [
      "activesupport"
      "attr_required"
      "httpclient"
      "json-jwt"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TnKnndaoZmkuhEIqVSsnw4paGRje0GZh4EkQ8rvmdro=";
      type = "gem";
    };
    version = "1.21.3";
  };
  rack-protection = {
    dependencies = [
      "base64"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PHS6f8WQZkU9Ya+by6W2/nqbPatvRFQY07OR1eqO+/8=";
      type = "gem";
    };
    version = "3.2.0";
  };
  rack-proxy = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RGpLVwAQIhRdXDunO3dfZqImDq90IMaQdIMUGQA5XIo=";
      type = "gem";
    };
    version = "0.7.7";
  };
  rack-session = {
    dependencies = [ "rack" ];
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oCEV5UILTeA2g5uYEeP3ln1zRGpVS0KqRRBq8zWFHXY=";
      type = "gem";
    };
    version = "1.0.2";
  };
  rack-test = {
    dependencies = [ "rack" ];
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DGH8YZBASdaRki6ku5nigATtP0OqXP1JUCTMNF8SXfs=";
      type = "gem";
    };
    version = "2.1.0";
  };
  rackup = {
    dependencies = [
      "rack"
      "webrick"
    ];
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6V4+G38fVKw3MPqfECSQPLI+QkqQF4EZjUktMsYAefE=";
      type = "gem";
    };
    version = "1.0.0";
  };
  rails = {
    dependencies = [
      "actioncable"
      "actionmailbox"
      "actionmailer"
      "actionpack"
      "actiontext"
      "actionview"
      "activejob"
      "activemodel"
      "activerecord"
      "activestorage"
      "activesupport"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Ba6i7XtjkrQc4PwRRV3hGEVQJaQxtuozSnrCsQFgiAQ=";
      type = "gem";
    };
    version = "7.1.5.1";
  };
  rails-controller-testing = {
    dependencies = [
      "actionpack"
      "actionview"
      "activesupport"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dBRI21k2YHPob8llukA/iBxja3miw5pI0EhvJgcYLpQ=";
      type = "gem";
    };
    version = "1.0.5";
  };
  rails-dom-testing = {
    dependencies = [
      "activesupport"
      "minitest"
      "nokogiri"
    ];
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5RVxLkjfH2h6HXw4D9ewe4VY+qJkZEdNpkGDp0JvqTs=";
      type = "gem";
    };
    version = "2.2.0";
  };
  rails-html-sanitizer = {
    dependencies = [
      "loofah"
      "nokogiri"
    ];
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NfziyoJC2od1yDtrqcG8qtZ1HZ63PBq6qEA0dauJpWA=";
      type = "gem";
    };
    version = "1.6.2";
  };
  rails-i18n = {
    dependencies = [
      "i18n"
      "railties"
    ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-wYTbgKfHvyHBTg5AD+nifEwgMS8Bmq/1s2SoKFjcE2k=";
      type = "gem";
    };
    version = "7.0.9";
  };
  railties = {
    dependencies = [
      "actionpack"
      "activesupport"
      "irb"
      "rackup"
      "rake"
      "thor"
      "zeitwerk"
    ];
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-C+FVYuLe1O/cG2ww+IS22DjJuklXPd4EIzS3UrBD4vs=";
      type = "gem";
    };
    version = "7.1.5.1";
  };
  rainbow = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-A5SRqjqJ9C76HW3sL8TmLt6W62rNleUvGtWBGCt5vGo=";
      type = "gem";
    };
    version = "3.1.1";
  };
  rake = {
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Rss42uZdfXS2AgpKydSK/tjrgUnAQOzPBSO+yRkHBZ0=";
      type = "gem";
    };
    version = "13.2.1";
  };
  rdf = {
    dependencies = [
      "bcp47_spec"
      "bigdecimal"
      "link_header"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lg7rIvtENOxbb02s9lJWcl2wQ9rHiaSg3HzyIFelitY=";
      type = "gem";
    };
    version = "3.3.2";
  };
  rdf-normalize = {
    dependencies = [ "rdf" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kjdEl93bYcKRC1C/wSuwrOM9zyPI7b0OD3j9Ss+Dnr4=";
      type = "gem";
    };
    version = "0.7.0";
  };
  rdoc = {
    dependencies = [ "psych" ];
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-sX1fD1ewhT17iA1DYKMsfK+Nu4H4UDo2Qm34CeYX83k=";
      type = "gem";
    };
    version = "6.7.0";
  };
  redcarpet = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-itGInANV/0xHF0rxTt0G1i9FoybaHabooSHVm9zS6ek=";
      type = "gem";
    };
    version = "3.6.0";
  };
  redis = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-OH7ghmlP/8ljKq6x7+SnsWJ8p4O/NzMgNGqKIM2TMzo=";
      type = "gem";
    };
    version = "4.8.1";
  };
  redis-namespace = {
    dependencies = [ "redis" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6RoaorLYiLbeodSrjTnhrm+sNCYWH+udkd1cylmKIjk=";
      type = "gem";
    };
    version = "1.11.0";
  };
  redlock = {
    dependencies = [ "redis" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bHzqPWLG4x6N9rGST9+J415VduUtzhDGJBLng7/jcnc=";
      type = "gem";
    };
    version = "1.3.2";
  };
  regexp_parser = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WifnZ61jT4pLVEUg1c0ooNt6oRmKXXydfhHXs9kGZEY=";
      type = "gem";
    };
    version = "2.9.2";
  };
  reline = {
    dependencies = [ "io-console" ];
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-FmDJaaeS69A05s7ujKYo87Zpjc2zT3ooKl7do3uVgWY=";
      type = "gem";
    };
    version = "0.5.10";
  };
  request_store = {
    dependencies = [ "rack" ];
    groups = [
      "default"
      "production"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LSxNNBylFa57pArnqqQ72QzTIL9p6BRWKnNpoNThpE0=";
      type = "gem";
    };
    version = "1.6.0";
  };
  responders = {
    dependencies = [
      "actionpack"
      "railties"
    ];
    groups = [
      "default"
      "pam_authentication"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kvKofgkCg0c2hjnPtGj1/vp0XLDcI3fvBg2xzdeaNBo=";
      type = "gem";
    };
    version = "3.1.1";
  };
  rexml = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1xh1uFKZ80Ht9H1E3wIS52WMvfNa62nO/bY/V68xN8k=";
      type = "gem";
    };
    version = "3.3.9";
  };
  rotp = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ddQAh+Ze0NgCLDMFWmMGwcQA0cEiYZMlM7XWy82GiFQ=";
      type = "gem";
    };
    version = "6.3.0";
  };
  rouge = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nuPZ7FMzjnjAP/8MvNCIgdgNaRUjSbBGdh5IzPLeWBw=";
      type = "gem";
    };
    version = "4.3.0";
  };
  rpam2 = {
    groups = [
      "default"
      "pam_authentication"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Yzi/blYmStNVXDAOxrzN0qkRS50sOv8OFQ6GT/SIdP8=";
      type = "gem";
    };
    version = "4.0.2";
  };
  rqrcode = {
    dependencies = [
      "chunky_png"
      "rqrcode_core"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-I+6oi7RMfubWyrk1TQjCh/frzcYRLh/nvMLQENH/78E=";
      type = "gem";
    };
    version = "2.2.0";
  };
  rqrcode_core = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-z0mJ3ILSTih3mEc4xO5WkwhiX+0qgQlg8bAtaNAwjRo=";
      type = "gem";
    };
    version = "1.2.0";
  };
  rspec = {
    dependencies = [
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1JCRSsHVpaZKDhQAwdVN3SpQEyTXA7jP6D9Fgze6uZM=";
      type = "gem";
    };
    version = "3.13.0";
  };
  rspec-core = {
    dependencies = [ "rspec-support" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-napP8pgS5iAZPryJUuAy8DH+Fnqfba9+o9Kdwx1HyGg=";
      type = "gem";
    };
    version = "3.13.1";
  };
  rspec-expectations = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Vl+5SrOZI8D+ahbPyVcNGCG3QZF6UIADc/y7t1LHpFo=";
      type = "gem";
    };
    version = "3.13.2";
  };
  rspec-github = {
    dependencies = [ "rspec-core" ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-VVoB3j++bg6+HR7V+gJ7EbhQWBukZ9AMWNeJXVCrEk8=";
      type = "gem";
    };
    version = "2.4.0";
  };
  rspec-mocks = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CHGJiZwzeTe88dZqUNw/yZmsiDNbvrpNOFwqOMh9ezg=";
      type = "gem";
    };
    version = "3.13.1";
  };
  rspec-rails = {
    dependencies = [
      "actionpack"
      "activesupport"
      "railties"
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
      "rspec-support"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-rSssttq8oHImDiGxiAWWRbrBBllGbAKmdPmtX9l7kvk=";
      type = "gem";
    };
    version = "7.0.1";
  };
  rspec-sidekiq = {
    dependencies = [
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
      "sidekiq"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vV0JWKm2Jw70o90XLLKwZOVyzMl/kyErkP0a2NiISyM=";
      type = "gem";
    };
    version = "5.0.0";
  };
  rspec-support = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SId9TxW3crdTjzaTwiIl8u2kkLploFFcTnz28vF95w8=";
      type = "gem";
    };
    version = "3.13.1";
  };
  rubocop = {
    dependencies = [
      "json"
      "language_server-protocol"
      "parallel"
      "parser"
      "rainbow"
      "regexp_parser"
      "rubocop-ast"
      "ruby-progressbar"
      "unicode-display_width"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BnnCY7EWT9ADuFkK6Ds+npv3IoLUEXVfIn8dYmjuXuc=";
      type = "gem";
    };
    version = "1.66.1";
  };
  rubocop-ast = {
    dependencies = [ "parser" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QCAehhxzo8LVlCjHYngo74H7L4owa8ShwYAUUq/j/g8=";
      type = "gem";
    };
    version = "1.32.3";
  };
  rubocop-capybara = {
    dependencies = [ "rubocop" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XSZO/di2xwgaPUiJ3s8UUaHPquwgTYFTTiNryCWygKs=";
      type = "gem";
    };
    version = "2.21.0";
  };
  rubocop-performance = {
    dependencies = [
      "rubocop"
      "rubocop-ast"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ntlzevHukGVWVLSD4OrE5kcCE56F0zM1v3RLV6MJpnk=";
      type = "gem";
    };
    version = "1.22.1";
  };
  rubocop-rails = {
    dependencies = [
      "activesupport"
      "rack"
      "rubocop"
      "rubocop-ast"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-9VYaCdav0vVDFvPw9gVzOMpVtsJKJbpqk40+0P3thK0=";
      type = "gem";
    };
    version = "2.26.2";
  };
  rubocop-rspec = {
    dependencies = [ "rubocop" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xqjin7GwDSJ8Mt8VnpL167ng/3NOUpVfsTr/XHSXfg8=";
      type = "gem";
    };
    version = "3.0.5";
  };
  rubocop-rspec_rails = {
    dependencies = [
      "rubocop"
      "rubocop-rspec"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-iIES6D+dfvetI5fp1poLlhSkuuJPByw5mAShgPgMTEY=";
      type = "gem";
    };
    version = "2.30.0";
  };
  ruby-prof = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BZaH11ZqLXTOk5iMqZa6u4w9LpILWDIeIsJEum2nykI=";
      type = "gem";
    };
    version = "1.7.0";
  };
  ruby-progressbar = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gPycR6m2QNaDTg3Hs8lMnfN/CMsHK3dh5KceIs/ymzM=";
      type = "gem";
    };
    version = "1.13.0";
  };
  ruby-saml = {
    dependencies = [
      "nokogiri"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3jQqVZJf1c5hFNCAJlHDJEKMD+wm5/5Svzp8+lTb+m0=";
      type = "gem";
    };
    version = "1.18.0";
  };
  ruby-vips = {
    dependencies = [
      "ffi"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QdErGoBc1urUp5ZSAaj3xf5Fm7WNOn2WfJ6wcZpu3JI=";
      type = "gem";
    };
    version = "2.2.3";
  };
  ruby2_keywords = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/9E3QMVztzAc96LmH8hXsqjj06/zJUXW+DANi64Q4+8=";
      type = "gem";
    };
    version = "0.0.5";
  };
  rubyzip = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-P1fjk13CJVxBRIT7+NZztJCdimpXAH7XVN3jk0LSNz8=";
      type = "gem";
    };
    version = "2.3.2";
  };
  rufus-scheduler = {
    dependencies = [ "fugit" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-X8oHfKA5oAJfp3/MdIT6ZOR6ESEkurx11MByrQVDmZI=";
      type = "gem";
    };
    version = "3.9.1";
  };
  safety_net_attestation = {
    dependencies = [ "jwt" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lr4tdOftJkU6UYlJE0Sb6g4HL0RJACFUWsLRw4sHGM4=";
      type = "gem";
    };
    version = "0.4.0";
  };
  sanitize = {
    dependencies = [
      "crass"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pCzl+TPYJ2WoJDWZ1asuiGcjfnbPWmmcqt3+YLuUQVI=";
      type = "gem";
    };
    version = "6.1.3";
  };
  scenic = {
    dependencies = [
      "activerecord"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-MZIKsfOqAOizmqJz68sQcngGouL8EAFGtXr8B55TDXA=";
      type = "gem";
    };
    version = "1.8.0";
  };
  securerandom = {
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zFGT1BSkNBtuIl8MtERqzsqOUNXhiIdD+sFph2OOoLE=";
      type = "gem";
    };
    version = "0.4.1";
  };
  selenium-webdriver = {
    dependencies = [
      "base64"
      "logger"
      "rexml"
      "rubyzip"
      "websocket"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-fhGr8rD9Vt9h2YttWdYheBzxAyYdlB3zUQg3VHvUoNU=";
      type = "gem";
    };
    version = "4.25.0";
  };
  semantic_range = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-MGZ3e6VG+AcGDTyTiS1cUu/0D0X9SKyUzvSW9PZJl7Y=";
      type = "gem";
    };
    version = "3.0.0";
  };
  shoulda-matchers = {
    dependencies = [ "activesupport" ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kFW7f0uzQhJfuGCAl5iFXGMOBe9edYN7MWi45u4WCLA=";
      type = "gem";
    };
    version = "6.4.0";
  };
  sidekiq = {
    dependencies = [
      "connection_pool"
      "rack"
      "redis"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tPk7IgTEIiDQtSanuODEm1+dqCwc4aBdK68ej3RMGX8=";
      type = "gem";
    };
    version = "6.5.12";
  };
  sidekiq-bulk = {
    dependencies = [ "sidekiq" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uxM4Xw6FQuIRpL8BqLe/RZOWgHSEDu9UjoIc9+rv3iI=";
      type = "gem";
    };
    version = "0.2.0";
  };
  sidekiq-scheduler = {
    dependencies = [
      "rufus-scheduler"
      "sidekiq"
      "tilt"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qkn6mC+w1Y4+lNa8LiGHvgAEFLk1Sp814M0G3iBK1b4=";
      type = "gem";
    };
    version = "5.0.6";
  };
  sidekiq-unique-jobs = {
    dependencies = [
      "brpoplpush-redis_script"
      "concurrent-ruby"
      "redis"
      "sidekiq"
      "thor"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IAVL8kCnjuBYNYXEWtLirLKspGcg4a5TD38I0B0/oao=";
      type = "gem";
    };
    version = "7.1.33";
  };
  simple-navigation = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mHx5z7lCRoRwVU2oprr7Fvq1Ganq0dqdZNVjyK/KgfE=";
      type = "gem";
    };
    version = "4.4.0";
  };
  simple_form = {
    dependencies = [
      "actionpack"
      "activemodel"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-OJGjaomn+MafE2FiTFNXWRV4qenDGCV817nMe2zkdGA=";
      type = "gem";
    };
    version = "5.3.1";
  };
  simplecov = {
    dependencies = [
      "docile"
      "simplecov-html"
      "simplecov_json_formatter"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/iYix4NP8juYBmuwqFQoSycppWmsZZ+CYh/CLvNiE6U=";
      type = "gem";
    };
    version = "0.22.0";
  };
  simplecov-html = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SxqtMyWf+6iynGh2wS23DldQy534KUhuTG5dpPoKoHs=";
      type = "gem";
    };
    version = "0.12.3";
  };
  simplecov-lcov = {
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ARXzHLfvXsQzT12TgsZ/1D3i5ScOIbZb/Gk9qC3XE8E=";
      type = "gem";
    };
    version = "0.8.0";
  };
  simplecov_json_formatter = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UpQY++jeFxOsKy1hKqPapW0xaXXTByRDmfpIOMYBtCg=";
      type = "gem";
    };
    version = "0.1.4";
  };
  stackprof = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7kCMvMzZQiqr1m7f+Ldqd9Z5VfLuG2dJYbXfqizHuL0=";
      type = "gem";
    };
    version = "0.2.26";
  };
  stoplight = {
    dependencies = [ "redlock" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qBuw2ZnPCjPQwm6EvZjHVw4TUYq9X5jWwEG+xav5A2M=";
      type = "gem";
    };
    version = "4.1.0";
  };
  stringio = {
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-U0VuFBdcWU4OjrIgahvjPzl01P4hwTHmKJCLBcjCrh4=";
      type = "gem";
    };
    version = "3.1.1";
  };
  strong_migrations = {
    dependencies = [ "activerecord" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-iHUPKUQD4Y7GdO2mkB8vwZX1U+1qeSjFLoo/W1f/UB0=";
      type = "gem";
    };
    version = "2.0.0";
  };
  swd = {
    dependencies = [
      "activesupport"
      "attr_required"
      "httpclient"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vDgqGeHTapVSmyUVKXbbYbgDdsPUhrIcjdYKwrXAY4k=";
      type = "gem";
    };
    version = "1.3.0";
  };
  sysexits = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WYJBxK5XuqQDwSUYLf3MDRrEwPtgbdR/vtV+Sq95VmI=";
      type = "gem";
    };
    version = "1.2.0";
  };
  temple = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3zFF/mV3rx4lOH639xItMu1Rvbby57sPT78HtmFRkTs=";
      type = "gem";
    };
    version = "0.10.3";
  };
  terminal-table = {
    dependencies = [ "unicode-display_width" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+VG2r18+ACA/spCmaeCoXF3VsFGzsCM5LM/We6WrrpE=";
      type = "gem";
    };
    version = "3.0.2";
  };
  terrapin = {
    dependencies = [ "climate_control" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3eL1hAwvl1TtJuPTZBORDF1+2KaxZeq+SJ60qn5HJk0=";
      type = "gem";
    };
    version = "1.0.1";
  };
  test-prof = {
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-llwcIUKyIEAFEWsSyLeMJRpW+R3UcyFGAKVUUlndzdc=";
      type = "gem";
    };
    version = "1.4.2";
  };
  thor = {
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7vApO54kFYzK16s4Oug1NLetTtmcCflvGmsDZVCrvto=";
      type = "gem";
    };
    version = "1.3.2";
  };
  tilt = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-33TymkUdrtJlkahejgzrsZiJLLdbZXM5QwOs2ic/uk0=";
      type = "gem";
    };
    version = "2.4.0";
  };
  timeout = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lQnwebK1X+QjbXljO9deNMHB5+P7S1bLX9ph+AoP4w4=";
      type = "gem";
    };
    version = "0.4.3";
  };
  tpm-key_attestation = {
    dependencies = [
      "bindata"
      "openssl"
      "openssl-signature_algorithm"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PBMVvtBro1Y67pj/acJw2bRbWGpDrC2iULI8rTw8rKM=";
      type = "gem";
    };
    version = "0.12.1";
  };
  tty-color = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-b5w3yjpOI2f7Lm0JcidiZH1vRVwRHwW1nzVzDuskMyo=";
      type = "gem";
    };
    version = "0.6.0";
  };
  tty-cursor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eVNBheand4iNiGKLFLah/fUVSmA/KF+AsXU+GQjgv0g=";
      type = "gem";
    };
    version = "0.7.1";
  };
  tty-prompt = {
    dependencies = [
      "pastel"
      "tty-reader"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/NvOkFI4mT8n7s/fZ1l6Y2vIOdkhkvag7vIrgWZEnsg=";
      type = "gem";
    };
    version = "0.23.1";
  };
  tty-reader = {
    dependencies = [
      "tty-cursor"
      "tty-screen"
      "wisper"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xilyyYXAsVZvDlZ0O2p4gvl509wy/0ke1JCgdviZwrE=";
      type = "gem";
    };
    version = "0.9.0";
  };
  tty-screen = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-wJBlIRW+rnZDNsKIAtYz8gT7hNqTxqloql2OMZ6Bm1A=";
      type = "gem";
    };
    version = "0.8.2";
  };
  twitter-text = {
    dependencies = [
      "idn-ruby"
      "unf"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-f6Szq/OAuibztNMQ9Bxv7KsMDxN+fVHWsgHQIRe41bY=";
      type = "gem";
    };
    version = "3.1.0";
  };
  tzinfo = {
    dependencies = [ "concurrent-ruby" ];
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
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
      hash = "sha256-cigisBXXEa1XqPmOMjpvgUWFzEl4CSCOZrWIotLuhrM=";
      type = "gem";
    };
    version = "1.2024.2";
  };
  unf = {
    dependencies = [ "unf_ext" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SZlRelMfKpVXUPiDGUGJH2FYSY7Jtsscgc6JOI5jAi4=";
      type = "gem";
    };
    version = "0.1.4";
  };
  unf_ext = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kmEUqFiTQSbGu/0yVDR9rbXa41RxGGk2jA9143Zfxuk=";
      type = "gem";
    };
    version = "0.0.9.1";
  };
  unicode-display_width = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-fnaB3K3hrdcMuf2iDdd/MAuFh8geu9Fl0U/ZMUT/CrQ=";
      type = "gem";
    };
    version = "2.5.0";
  };
  uri = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pVcZbmUgEbz/CzbSn55Cf+/PYMw1wKuMzgh2imKH5Fc=";
      type = "gem";
    };
    version = "0.13.2";
  };
  validate_email = {
    dependencies = [
      "activemodel"
      "mail"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nf6QFtUnsXqNOm6V5NxQoSVADu+JnRPUzColQ5P4LuQ=";
      type = "gem";
    };
    version = "0.1.6";
  };
  validate_url = {
    dependencies = [
      "activemodel"
      "public_suffix"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cv4WTAcT1jqZcL1nAL6pSLq7+9zsOS8jQrZwQEL1dFE=";
      type = "gem";
    };
    version = "1.0.15";
  };
  warden = {
    dependencies = [ "rack" ];
    groups = [
      "default"
      "pam_authentication"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RmhPiF01pp27iD3qv4WiIsjkJ6lXgEcZ4UMAXfeh79A=";
      type = "gem";
    };
    version = "1.2.9";
  };
  webauthn = {
    dependencies = [
      "android_key_attestation"
      "awrence"
      "bindata"
      "cbor"
      "cose"
      "openssl"
      "safety_net_attestation"
      "tpm-key_attestation"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5UX88X2Ka4IRYaN8HEvIw9Lq0P9v87CY9X9BfnMXkLc=";
      type = "gem";
    };
    version = "3.1.0";
  };
  webfinger = {
    dependencies = [
      "activesupport"
      "httpclient"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eBTvHIXaR1FPZcblyhQgX6nOQeoqcHheDIcoQhYoUqI=";
      type = "gem";
    };
    version = "1.2.0";
  };
  webmock = {
    dependencies = [
      "addressable"
      "crack"
      "hashdiff"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vgE1f2/Hc2BjN8p587ozK31Sy+XCdYdnGrwFctvscSI=";
      type = "gem";
    };
    version = "3.24.0";
  };
  webpacker = {
    dependencies = [
      "activesupport"
      "rack-proxy"
      "railties"
      "semantic_range"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cfwizU5HvK4doTrv2CYnFTDNkj9mUooEPzDgiGXcBDo=";
      type = "gem";
    };
    version = "5.4.4";
  };
  webpush = {
    dependencies = [
      "hkdf"
      "jwt"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      fetchSubmodules = false;
      rev = "f14a4d52e201128b1b00245d11b6de80d6cfdcd9";
      hash = "sha256-tzI1628jXjhxJIQj26tteRjW9d++ydrzxcrzngAi478=";
      type = "git";
      url = "https://github.com/ClearlyClaire/webpush.git";
    };
    version = "0.3.8";
  };
  webrick = {
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QxdGo0kZlUb/ndJyyuEISchl+TghbkHEAqZIkkjxLyE=";
      type = "gem";
    };
    version = "1.8.2";
  };
  websocket = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-t+enTiQQtehcJYWLJrMyLykWHjAJNfcKDg08NeBGJzc=";
      type = "gem";
    };
    version = "1.2.11";
  };
  websocket-driver = {
    dependencies = [ "websocket-extensions" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-9pQAvnvBl4eXJq2Ob1hpphgjFHNy/Ykog2pTwsdB0Ns=";
      type = "gem";
    };
    version = "0.7.6";
  };
  websocket-extensions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HGumMJLNo0PrU/xlcRDHHHVMVkhKrUJXhJUifXF6gkE=";
      type = "gem";
    };
    version = "0.1.5";
  };
  wisper = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zhe8XDoWbyQaLmYThIsCXIFG/OLe+6UFkgwdHz+I+uY=";
      type = "gem";
    };
    version = "2.0.1";
  };
  xorcist = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-aQyX2aO7cnHuXL/XORWPlESWy3L9DB1Vstsx2pGPa7U=";
      type = "gem";
    };
    version = "1.1.3";
  };
  xpath = {
    dependencies = [ "nokogiri" ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bf2nnZG7O5SblH7MWRnwQu8vOZuQQBPrPvbSDdOkCC4=";
      type = "gem";
    };
    version = "3.2.0";
  };
  zeitwerk = {
    groups = [
      "default"
      "development"
      "pam_authentication"
      "production"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vS0hOZb/ezs2TNNCpYX77peX28HAxtho3EFQzHVzl4E=";
      type = "gem";
    };
    version = "2.6.18";
  };
}
