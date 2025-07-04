{
  activesupport = {
    dependencies = [
      "concurrent-ruby"
      "i18n"
      "minitest"
      "tzinfo"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-30cCN13pJKroFwnIMWBTF8VBfwvZ5QKgNz/4SgZyBP8=";
      type = "gem";
    };
    version = "7.0.8.7";
  };
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
  ast = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lUYVFXwdajgrwn1pDZcxleedt/Vel2WsfEgcYL2004M=";
      type = "gem";
    };
    version = "2.4.3";
  };
  aws-eventstream = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EWv4XENiANEGCBHm9dLUDIj2VEjyElvHf/zlEh5uGDs=";
      type = "gem";
    };
    version = "1.4.0";
  };
  aws-partitions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gxe8lIUGdtj/aZoKFPq/4IKfEKBOktPnslr4kprZsoU=";
      type = "gem";
    };
    version = "1.1110.0";
  };
  aws-sdk-core = {
    dependencies = [
      "aws-eventstream"
      "aws-partitions"
      "aws-sigv4"
      "base64"
      "jmespath"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-fErYi0iYNasXs0KmIeggyldZ6rBLaKMiE9ALlZRSTs0=";
      type = "gem";
    };
    version = "3.225.0";
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
      hash = "sha256-RDywGyg6OYY+9ZYD7I9do4gQMknuAvSJ37IxuV7CKsM=";
      type = "gem";
    };
    version = "1.102.0";
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
      hash = "sha256-KmIvptcv/v0+Yj2wBlD8nXsXegCGJqSf3ithJbWmfnQ=";
      type = "gem";
    };
    version = "1.189.0";
  };
  aws-sdk-secretsmanager = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-sYmNfwwMzrw35K+rQt/aH2PkbwCG3Z1f+xGBetu5GlI=";
      type = "gem";
    };
    version = "1.116.0";
  };
  aws-sigv4 = {
    dependencies = [ "aws-eventstream" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bgj4P7oZ5k5nHfRgo0KjaDGkvzNoiM88vD9mWMwQjeU=";
      type = "gem";
    };
    version = "1.12.0";
  };
  base64 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JzN66rrW/64FwmXEUEkGKO8+vUtnvlglc5MidYj1qXs=";
      type = "gem";
    };
    version = "0.3.0";
  };
  bigdecimal = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-H2hjHodsarqP6bhLNpg8Va0yk/8tGtTG8RW94enYAuM=";
      type = "gem";
    };
    version = "3.2.1";
  };
  builder = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SXkY0vncpSj9ykuI2E5O9DhyVtmEuBVOnV0/5anIg18=";
      type = "gem";
    };
    version = "3.3.0";
  };
  chef = {
    dependencies = [
      "addressable"
      "aws-sdk-s3"
      "aws-sdk-secretsmanager"
      "chef-config"
      "chef-utils"
      "chef-vault"
      "chef-zero"
      "corefoundation"
      "diff-lcs"
      "erubis"
      "ffi"
      "ffi-libarchive"
      "ffi-yajl"
      "iniparse"
      "inspec-core"
      "license-acceptance"
      "mixlib-archive"
      "mixlib-authentication"
      "mixlib-cli"
      "mixlib-log"
      "mixlib-shellout"
      "net-ftp"
      "net-sftp"
      "ohai"
      "plist"
      "proxifier2"
      "syslog-logger"
      "train-core"
      "train-rest"
      "train-winrm"
      "unf_ext"
      "uuidtools"
      "vault"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-FTbm7ffvtnQ4QXx/ktSTd0AUQMCZRNAh9rHCGcl7B2s=";
      type = "gem";
    };
    version = "18.7.10";
  };
  chef-cli = {
    dependencies = [
      "addressable"
      "chef"
      "cookbook-omnifetch"
      "diff-lcs"
      "ffi-yajl"
      "license-acceptance"
      "minitar"
      "mixlib-cli"
      "mixlib-shellout"
      "pastel"
      "solve"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-R4HocAks8WE9+h9rP6U0DH4Th5JGYM+NUVI59FEE7iA=";
      type = "gem";
    };
    version = "5.6.21";
  };
  chef-config = {
    dependencies = [
      "addressable"
      "chef-utils"
      "fuzzyurl"
      "mixlib-config"
      "mixlib-shellout"
      "tomlrb"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hMKnKVXQm4AcpvL+W45bvb6vLdYIYcH9Z6C65C3fcX8=";
      type = "gem";
    };
    version = "18.7.10";
  };
  chef-gyoku = {
    dependencies = [
      "builder"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SAadn+cJr+kY8X5jXztDahuZbHtyd66rdba7yL6wsjo=";
      type = "gem";
    };
    version = "1.4.5";
  };
  chef-telemetry = {
    dependencies = [
      "chef-config"
      "concurrent-ruby"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vQBP0gzQZ3k2062ogbHTGBhadhhuF3RjRUI2ZwdjMVE=";
      type = "gem";
    };
    version = "1.1.1";
  };
  chef-utils = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zZNDPlDVJtSWo39so7B7Zdwp83uMYyMfIqoVkkxLmaQ=";
      type = "gem";
    };
    version = "18.7.10";
  };
  chef-vault = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HOmaK0BW6YxZ/dOL5xqdjdDvGW6glZowizv07DtLBfM=";
      type = "gem";
    };
    version = "4.1.23";
  };
  chef-winrm = {
    dependencies = [
      "builder"
      "chef-gyoku"
      "erubi"
      "ffi"
      "gssapi"
      "httpclient"
      "logging"
      "nori"
      "rexml"
      "rubyntlm"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7Qo4ltW0cIyIvD85tf+kJv/oiVUodNR1nsCawRkVl1I=";
      type = "gem";
    };
    version = "2.3.12";
  };
  chef-winrm-elevated = {
    dependencies = [
      "chef-winrm"
      "chef-winrm-fs"
      "erubi"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mYW06x5bv74dueS76imld17p5ufVLPu5eHvKtgX/WAc=";
      type = "gem";
    };
    version = "1.2.5";
  };
  chef-winrm-fs = {
    dependencies = [
      "chef-winrm"
      "erubi"
      "logging"
      "rubyzip"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1I5WvIpVmvquOSNbCd84F/A7ZiQXOWCR0T2VgDDYmhQ=";
      type = "gem";
    };
    version = "1.3.7";
  };
  chef-zero = {
    dependencies = [
      "activesupport"
      "ffi-yajl"
      "hashie"
      "mixlib-log"
      "rack"
      "rackup"
      "uuidtools"
      "webrick"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Qj4YSZteB6objLyqHJEC9b1e319pL2Sx0OnqkYEIc1c=";
      type = "gem";
    };
    version = "15.0.17";
  };
  coderay = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3FMAGKRoRRL484FDzSoJbJ8CofwkWe3P5TR4en/HfUs=";
      type = "gem";
    };
    version = "1.1.3";
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
  cookbook-omnifetch = {
    dependencies = [ "mixlib-archive" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-VvhtdVCbS5r4ad4raqzaNUV5PNDHsH0xGuR1Z64xEL8=";
      type = "gem";
    };
    version = "0.12.2";
  };
  cookstyle = {
    dependencies = [ "rubocop" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8urp6FFno4b1XmgSeQ4SfPtholp5xcAN0Mh/R/nh5K8=";
      type = "gem";
    };
    version = "8.1.4";
  };
  corefoundation = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KcB3ZswdfkKLEWuevgOxa7gp75EE8PqP/4maYdrwL5M=";
      type = "gem";
    };
    version = "0.3.13";
  };
  date = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vyaOFO9xWACb/q7EC1+jxycZBuiLGW2VionUtAir5k8=";
      type = "gem";
    };
    version = "3.4.1";
  };
  diff-lcs = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JzIj37QGhVSENtMrRzOqZzUXacfepiHafZ3UgT5j3f4=";
      type = "gem";
    };
    version = "1.5.1";
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
  erubi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oIIQOwiF28Xs8Rcv7eiX+evbdFpLl6Xo3GOVPbHuStk=";
      type = "gem";
    };
    version = "1.13.1";
  };
  erubis = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Y2U/UXSnmX9vHW9GX74UlNzEvasfuOY19iFpifsRSLo=";
      type = "gem";
    };
    version = "2.7.0";
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
      hash = "sha256-zFMetUZ+fXTUUXYw+pbxpwA2R8vyCpo+Bn0JiUEhe3U=";
      type = "gem";
    };
    version = "2.13.1";
  };
  faraday-follow_redirects = {
    dependencies = [ "faraday" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2S2XVjXix/5SXdSU/NS5u38KSg7A1fTBXHKVMP24B/k=";
      type = "gem";
    };
    version = "0.3.0";
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
  ffi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bTJC/xDIcnGwZ1xY1o0/EBSPq8KtbaUqGBI/BgeIcfs=";
      type = "gem";
    };
    version = "1.16.3";
  };
  ffi-libarchive = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-o+TKlITuStdUrQT8wUoSaG1I0UY8JkFz1vj/Ck34FqY=";
      type = "gem";
    };
    version = "1.1.14";
  };
  ffi-yajl = {
    dependencies = [ "libyajl2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-abqmEic5keTHlmdGTrJfP+sWmJmqszkpozsDI0ryQzY=";
      type = "gem";
    };
    version = "2.6.0";
  };
  fuzzyurl = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-VC76gPK8qtvcQCwvC1cvLjNaHVPjda7K1ou7PYaGDA8=";
      type = "gem";
    };
    version = "0.9.0";
  };
  gssapi = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xRzzCELuOb2Tzn/DPiBAX/igTNqd7GCSBxthJYKEruE=";
      type = "gem";
    };
    version = "1.3.1";
  };
  hashie = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eJDcuewYpLZqzseXAYxzgkuJzvXrjNo26OhQGEXoegk=";
      type = "gem";
    };
    version = "4.1.0";
  };
  http-accept = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xiaGBoK/uztGRi+MOc1HD9ewWE9hs8yd9bLp65lyoSY=";
      type = "gem";
    };
    version = "1.7.0";
  };
  http-cookie = {
    dependencies = [ "domain_name" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-sU/gRFzyS/muCYYz6bjULkwHw8H3AGcrCfv+Mv/UGqY=";
      type = "gem";
    };
    version = "1.0.8";
  };
  httpclient = {
    dependencies = [ "mutex_m" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-S2RZWOSUsvhsL4ovMEyVm6onOjEOd6KTHduYbYPkmMg=";
      type = "gem";
    };
    version = "2.9.0";
  };
  i18n = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zrpXP4E4/ywJFUJ/H8W99Ko6uK6IyM4lXrPs8KEaXQ8=";
      type = "gem";
    };
    version = "1.14.7";
  };
  iniparse = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NqFl6Y2KJQt2McSn+a+6Mq948ImXDNZEajl3EYnHYfE=";
      type = "gem";
    };
    version = "1.5.0";
  };
  inspec-core = {
    dependencies = [
      "addressable"
      "chef-telemetry"
      "cookstyle"
      "faraday"
      "faraday-follow_redirects"
      "hashie"
      "license-acceptance"
      "method_source"
      "mixlib-log"
      "multipart-post"
      "parallel"
      "parslet"
      "pry"
      "rspec"
      "rspec-its"
      "rubyzip"
      "semverse"
      "sslshake"
      "thor"
      "tomlrb"
      "train-core"
      "tty-prompt"
      "tty-table"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8SZdoqZjZLnl53b/4VmhkgLxRIPLbmy+acAoU5X+Jos=";
      type = "gem";
    };
    version = "5.22.80";
  };
  ipaddress = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hWQMT5GUwmk3r8jHjjB0qOfJfV0SEDWNFEDwEDTQBvU=";
      type = "gem";
    };
    version = "0.8.3";
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
      hash = "sha256-upSkitJlYFyPqaUKWJLzumoCZhqgEPY4IR88s29Eq/Q=";
      type = "gem";
    };
    version = "2.12.2";
  };
  language_server-protocol = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/R45pRoovz7slZN5mFpy4pbp+az85G9qedMcqHYIA8w=";
      type = "gem";
    };
    version = "3.17.0.5";
  };
  libyajl2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ql32xyV3b8BQyEGEUN4PfBKctyALgRkHxMCztcCuoO8=";
      type = "gem";
    };
    version = "2.1.0";
  };
  license-acceptance = {
    dependencies = [
      "pastel"
      "tomlrb"
      "tty-box"
      "tty-prompt"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7sslm4etrr8WLNJeYTsOD20wBckv/Xbd7KDAU+RQBYo=";
      type = "gem";
    };
    version = "2.1.13";
  };
  lint_roller = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LAyEW2MqfRcsuEnMkMG86TeijFyMzMtQ39RqSFADzIc=";
      type = "gem";
    };
    version = "1.1.0";
  };
  little-plugger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1fNHwA2dZIBA73wX1usJ09Bxmt8ZyjDRo7b7JtCmMbs=";
      type = "gem";
    };
    version = "1.1.4";
  };
  logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GW7ex8xEtmz7QPl1XOEbOS8h95Z2lq8V0nTd5+3/AgM=";
      type = "gem";
    };
    version = "1.7.0";
  };
  logging = {
    dependencies = [
      "little-plugger"
      "multi_json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uoiTo8IRuDb0Exu5Oz6zE3oMOx/NDsPVcOMk2L3ADMs=";
      type = "gem";
    };
    version = "2.4.0";
  };
  method_source = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GBMBycRbcxtHabyB6IYOcvkWGtfWbdmRA8mrhPVg9cU=";
      type = "gem";
    };
    version = "1.1.0";
  };
  mime-types = {
    dependencies = [
      "logger"
      "mime-types-data"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3Ov2HCRvCOFaTeNOOG6+gjN5HoaFZKRww/53wA7tXlY=";
      type = "gem";
    };
    version = "3.7.0";
  };
  mime-types-data = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EYCNeAzbJ+pdsBQ9v8JhuR7WPsXllfQko1+YIstJegI=";
      type = "gem";
    };
    version = "3.2025.0527";
  };
  minitar = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-sZLrK6dnKQbtU4U9IYgTCoSfHCRR5bLaxojZ9fdjRnI=";
      type = "gem";
    };
    version = "1.0.2";
  };
  minitest = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ORtsbLQ6SAK/t8k68evirGaiECk/Sj+32zby/H3Cx1Y=";
      type = "gem";
    };
    version = "5.25.5";
  };
  mixlib-archive = {
    dependencies = [ "mixlib-log" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ythtveHtz7KOxDRNTgdFHm831yBPgLohAqaQpxAEfJ8=";
      type = "gem";
    };
    version = "1.1.7";
  };
  mixlib-authentication = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xb5ESQzr+EgRcfCcwl5kZmOu465Y6i3m2flLySLCph4=";
      type = "gem";
    };
    version = "3.0.10";
  };
  mixlib-cli = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5vJ7401YD27XFzHKRrln5XeTpicTHB9uHtLa056jvfk=";
      type = "gem";
    };
    version = "2.1.8";
  };
  mixlib-config = {
    dependencies = [ "tomlrb" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-13SLGJjk8WUCr+wd4Ata1lxt5AURSxsMZexhsakQAUg=";
      type = "gem";
    };
    version = "3.0.27";
  };
  mixlib-log = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SXxoHkuM/m1uXJ0ob/hW8SIFP3BqJ+aYYajf4aSbkGk=";
      type = "gem";
    };
    version = "3.1.2.1";
  };
  mixlib-shellout = {
    dependencies = [ "chef-utils" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Dt9e47B1Jt6OtSGa8FF1L7jfJpHcAwziM+JI3t9P04g=";
      type = "gem";
    };
    version = "3.3.9";
  };
  molinillo = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-77/ycWMk4qMLzNProf86c19NXVP/3bxqLzLAypQzBF0=";
      type = "gem";
    };
    version = "0.8.0";
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
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-z8sErBa2nEgTd3Ai/c7aJOn3mOSAkqK4F+tMCngrB1E=";
      type = "gem";
    };
    version = "0.3.0";
  };
  net-ftp = {
    dependencies = [
      "net-protocol"
      "time"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KNY+QHp+25c5wyCk+q7FFeQ+ljgVJI0GQYq6MiR4h08=";
      type = "gem";
    };
    version = "0.3.8";
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
  net-protocol = {
    dependencies = [ "timeout" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qnPgy6ahJTad6YN7jY74KmGEk2DroFIZAOLDcTqhYqg=";
      type = "gem";
    };
    version = "0.2.2";
  };
  net-scp = {
    dependencies = [ "net-ssh" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qZsLkqHl02Cw3k/78twMkVMVAtPU9WwosBOafAk9Gl0=";
      type = "gem";
    };
    version = "4.1.0";
  };
  net-sftp = {
    dependencies = [ "net-ssh" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZbuRyFnC+TsJgmdXrxG2mvkxo6kVUFD1DRsG04RSY2Q=";
      type = "gem";
    };
    version = "4.0.0";
  };
  net-ssh = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-FyB2xLMM5W+yWgOWGwxNoU4SRkJkAbD4nLoaO1S/PvA=";
      type = "gem";
    };
    version = "7.3.0";
  };
  netrc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3hzjPajJmrHZeHFybLp1FRET8RcUa+y+RaqFyz2r7j8=";
      type = "gem";
    };
    version = "0.11.0";
  };
  nori = {
    dependencies = [ "bigdecimal" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-FAtderhVe5T0i1xJS07pCs0CnbWmsCIjOgmwL83Yjos=";
      type = "gem";
    };
    version = "2.7.0";
  };
  ohai = {
    dependencies = [
      "chef-config"
      "chef-utils"
      "ffi"
      "ffi-yajl"
      "ipaddress"
      "mixlib-cli"
      "mixlib-config"
      "mixlib-log"
      "mixlib-shellout"
      "plist"
      "train-core"
      "wmi-lite"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zHDyRCq/Pp0H0AFvE7HaUVzNXYWx3xQN2StCsxkc2UA=";
      type = "gem";
    };
    version = "18.2.6";
  };
  parallel = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SsFR4YBrdV+04twjMsvw5U8uJLqCH/LT3Phr9txK4TA=";
      type = "gem";
    };
    version = "1.27.0";
  };
  parser = {
    dependencies = [
      "ast"
      "racc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JHY2QUKzB/paGx7ORPJgcoviOFipxxB46VYTGnVFPEU=";
      type = "gem";
    };
    version = "3.3.8.0";
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
  plist = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-03pFJ8wRFgZDk99LQOHbvJTGX6nKLuxS7fmhNhZxikI=";
      type = "gem";
    };
    version = "3.7.2";
  };
  prism = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3A4+AOkxYCE9wqZVGdkAKkoee5YttX1ETPGnFWW7cD4=";
      type = "gem";
    };
    version = "1.4.0";
  };
  proxifier2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Aw7SSKZJx38q1kAZX1xXyfduXFalyfwMUsqO2XAAszI=";
      type = "gem";
    };
    version = "1.1.0";
  };
  pry = {
    dependencies = [
      "coderay"
      "method_source"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EtVLhkDT+inJIR3U/7CPP9i/ek/Ztac85bWchwk4W2s=";
      type = "gem";
    };
    version = "0.15.2";
  };
  public_suffix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-v6fNUQgGb4yWAuDW1BFJmaXfWDmmMUnT6LD5wdNVg5Q=";
      type = "gem";
    };
    version = "6.0.2";
  };
  racc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Sn9pKWkdvsi1IJoLNzvCYUiCtV/F0uRHohqqaRMD1i8=";
      type = "gem";
    };
    version = "1.8.1";
  };
  rack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0Ss+mWDRiibe2WElDywOOzdbSf9A2+Z4bpw7Fgy//KQ=";
      type = "gem";
    };
    version = "3.1.15";
  };
  rackup = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-9zcZH9XFs0i38KRBKjuGOD+IxD4TuCF7Y9TI2QueeY0=";
      type = "gem";
    };
    version = "2.2.1";
  };
  rainbow = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-A5SRqjqJ9C76HW3sL8TmLt6W62rNleUvGtWBGCt5vGo=";
      type = "gem";
    };
    version = "3.1.1";
  };
  regexp_parser = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-y28N3eiHcs1kv/Hbv2jfZtN2BD/i5mqe93/LGwxUjGE=";
      type = "gem";
    };
    version = "2.10.0";
  };
  rest-client = {
    dependencies = [
      "http-accept"
      "http-cookie"
      "mime-types"
      "netrc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NaZAC9sU+uKFlmGOMSd2wVj367sMytdS/0+hQr8nR+M=";
      type = "gem";
    };
    version = "2.1.0";
  };
  rexml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-x0UnqaCgS07DHb4NxO1gBLlgr5Q9jbQuU57d46hxq8o=";
      type = "gem";
    };
    version = "3.4.1";
  };
  rspec = {
    dependencies = [
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zMQXmaQ1CdwL6EBw4/BBCslcvUgK57bCRVQ+tkFiOZw=";
      type = "gem";
    };
    version = "3.12.0";
  };
  rspec-core = {
    dependencies = [ "rspec-support" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eCGJ3qWsKJcdKmE/978otMTjJuw/BQPHczB2cSabbw0=";
      type = "gem";
    };
    version = "3.12.3";
  };
  rspec-expectations = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hG/4loVRp3XEyUmCXVgfOUpRe994to/qxHEoKhsD51w=";
      type = "gem";
    };
    version = "3.12.4";
  };
  rspec-its = {
    dependencies = [
      "rspec-core"
      "rspec-expectations"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xAQxT5M//V724s+ocWfickd6cAdGfbXsWclq0WecUfY=";
      type = "gem";
    };
    version = "1.3.1";
  };
  rspec-mocks = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-svEKeHl4HelEjyjl3DmSd9TqwU1Xe0UOTAS3iX/kxqg=";
      type = "gem";
    };
    version = "3.12.7";
  };
  rspec-support = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3nGavcnQOELJYFK+Si2rjX/ZMU0LJIiw91UAjQcbdh0=";
      type = "gem";
    };
    version = "3.12.2";
  };
  rubocop = {
    dependencies = [
      "json"
      "language_server-protocol"
      "lint_roller"
      "parallel"
      "parser"
      "rainbow"
      "regexp_parser"
      "rubocop-ast"
      "ruby-progressbar"
      "unicode-display_width"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-yAq0KGxdz8SdetF4fNulVptjtYyW7nr95OxHqcioW+k=";
      type = "gem";
    };
    version = "1.75.8";
  };
  rubocop-ast = {
    dependencies = [
      "parser"
      "prism"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-C0red9FfJbngchT7QvqYFk9TFqzOpSXhTkS7uPBveNc=";
      type = "gem";
    };
    version = "1.45.0";
  };
  ruby-progressbar = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gPycR6m2QNaDTg3Hs8lMnfN/CMsHK3dh5KceIs/ymzM=";
      type = "gem";
    };
    version = "1.13.0";
  };
  rubyntlm = {
    dependencies = [ "base64" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RwE0Arma4p7pP5MK9R7a7IxgCFVvS+JXBaQitEMDFPU=";
      type = "gem";
    };
    version = "0.6.5";
  };
  rubyzip = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hXfIjtwf3ok165EGTFyxrvmtVJS5QM8Zx3Xugz4HVhU=";
      type = "gem";
    };
    version = "2.4.1";
  };
  semverse = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-yXJq7nhY03yElIpBAdr/3PA6CWOhKjOtfMOacsA1MO8=";
      type = "gem";
    };
    version = "3.0.2";
  };
  solve = {
    dependencies = [
      "molinillo"
      "semverse"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-fnpFwmy2FrsZZ+OAN6NCW5f/HVgX8XApm4VmQJzONBU=";
      type = "gem";
    };
    version = "4.0.4";
  };
  sslshake = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EGnJftk0QeHhwWf7WfDrlS9kFWeE2bMh9gUo1PV0cWQ=";
      type = "gem";
    };
    version = "1.3.1";
  };
  strings = {
    dependencies = [
      "strings-ansi"
      "unicode-display_width"
      "unicode_utils"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kzKTs8lc+FuB60Szz2c+MIdmG6c5u63+rfRCCDFY1vs=";
      type = "gem";
    };
    version = "0.2.1";
  };
  strings-ansi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kCYtdg6kqUzCro1YIFJ3o0NAnCiMvnwpQWsYJr1RHIg=";
      type = "gem";
    };
    version = "0.2.0";
  };
  syslog-logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dUHzRoHH0Q7WPo7oJzOwpg95Jkpu8/SJog3OgOEFwpM=";
      type = "gem";
    };
    version = "1.6.8";
  };
  thor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-L5PGUoKMup/PT2X13IwwbxpzF+BarVg1oTdAEiwX8kw=";
      type = "gem";
    };
    version = "1.2.2";
  };
  time = {
    dependencies = [ "date" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-A182BQikpNury7zTiGVmuavUMt6JE2eV0v967FvN6mE=";
      type = "gem";
    };
    version = "0.4.1";
  };
  timeout = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lQnwebK1X+QjbXljO9deNMHB5+P7S1bLX9ph+AoP4w4=";
      type = "gem";
    };
    version = "0.4.3";
  };
  tomlrb = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-aGZr9T+nC6aGpIp0Nc5+CG9SJ8WMTJk72XkvR2DypQM=";
      type = "gem";
    };
    version = "1.3.0";
  };
  train-core = {
    dependencies = [
      "addressable"
      "ffi"
      "json"
      "mixlib-shellout"
      "net-scp"
      "net-ssh"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-o5cpm5BiT2RMFzW4IyQYQoFKwIUh0dukT3HL/YgrQa8=";
      type = "gem";
    };
    version = "3.12.13";
  };
  train-rest = {
    dependencies = [
      "aws-sigv4"
      "rest-client"
      "train-core"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Y9yrs5YCJXDPHyGj53svZKizqFF5oLbivpGm//kmimM=";
      type = "gem";
    };
    version = "0.5.0";
  };
  train-winrm = {
    dependencies = [
      "chef-winrm"
      "chef-winrm-elevated"
      "chef-winrm-fs"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/ry72Hq8iipcqzg9E85JR5bQAYn+PA8VxFJxBEfqvbM=";
      type = "gem";
    };
    version = "0.2.19";
  };
  tty-box = {
    dependencies = [
      "pastel"
      "strings"
      "tty-cursor"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-F/RToMHfQ4cf223kYe55e3hXTazGUjcvoq6YoAeF34s=";
      type = "gem";
    };
    version = "0.7.0";
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
  tty-table = {
    dependencies = [
      "pastel"
      "strings"
      "tty-screen"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/cJ6R1CDXBoW7+GaC4V+PO02Usx6zq/m3KlJCJZbmTk=";
      type = "gem";
    };
    version = "0.12.0";
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
  unf_ext = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kLliPuNZzEh4RhxdLqt9PTzlgBpoCp56yDuAQMW3Qvo=";
      type = "gem";
    };
    version = "0.0.8.2";
  };
  unicode-display_width = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EieYdLum1eTScozvgUsZGX27ENeng3qGm6tl2pQ7f1o=";
      type = "gem";
    };
    version = "2.6.0";
  };
  unicode_utils = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uSLQzyMTtrcTatpmRc5xVP/IZBjKB9U7BY7+nrcvKkA=";
      type = "gem";
    };
    version = "1.4.0";
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
  uuidtools = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xK7RaBQXRtI1fOkHYmuDmYCErrPGrBZnCukCpGIZEGk=";
      type = "gem";
    };
    version = "2.2.0";
  };
  vault = {
    dependencies = [ "aws-sigv4" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KTRsLYNkwZ7/tUi3qJUr8YdUW5m3DR3d52vWxpBG0nw=";
      type = "gem";
    };
    version = "0.18.2";
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
  wmi-lite = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EW71u0cNvmD1jC25BHrzBkwWJF1lYsZGvA2Qh34n3do=";
      type = "gem";
    };
    version = "1.0.7";
  };
}
