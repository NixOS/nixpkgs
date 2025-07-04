{
  drydock = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0rvVvhuk3elJ5+7KFeZMl613qFPcVkk/oyPBGswYLj8=";
      type = "gem";
    };
    version = "0.6.9";
  };
  redis = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-G/+iNnfIV7UyN6kePuEj5Qa6Yg6puEwpGU0KP3ytZmY=";
      type = "gem";
    };
    version = "4.1.0";
  };
  redis-dump = {
    dependencies = [
      "drydock"
      "redis"
      "uri-redis"
      "yajl-ruby"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-j3+swRtfdp1lufvaXDVdKVpuUFrkT1ml3x3VN8e5cb8=";
      type = "gem";
    };
    version = "0.4.0";
  };
  uri-redis = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KqDXxq8vsykYjHi14eqVb/UQSY6XFEBrXXPGHMhUyI4=";
      type = "gem";
    };
    version = "0.4.2";
  };
  yajl-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bjLm5oHChh6Z5zievMpw1Wy5NXsiPwn7CFfiRE7hYJs=";
      type = "gem";
    };
    version = "1.4.1";
  };
}
