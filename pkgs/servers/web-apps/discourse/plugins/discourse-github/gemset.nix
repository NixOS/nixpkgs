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
      hash = "sha256-sa0Iir2jGzVmV8lpRL5aoqVUaVK2pH9alXI3Ctilqjc=";
      type = "gem";
    };
    version = "2.12.3";
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
  json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NODq2pMCKyoKM0W7C179226f9b58SOQJz7VP+KNqiwY=";
      type = "gem";
    };
    version = "2.10.2";
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
  octokit = {
    dependencies = [
      "faraday"
      "sawyer"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SO+ywqqDwsOUNY8HPTWtcdSsDxSHDNAM7r0+85Sf5JU=";
      type = "gem";
    };
    version = "5.6.1";
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
  sawyer = {
    dependencies = [
      "addressable"
      "faraday"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+jpy1ipFJVF7GIV923iSaqs0JN4BKb5ncqjiuiQOeso=";
      type = "gem";
    };
    version = "0.9.2";
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
}
