{
  djinni = {
    dependencies = [ "fagin" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-9BrBPSMV72qcWAJU8spq2KU+wuqP/a3tCriDMyVA86M=";
      type = "gem";
    };
    version = "2.2.4";
  };
  fagin = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RKgn8Am2SPU7iw/4uibEV+zipI8KlAz+DFo4SGDzXl8=";
      type = "gem";
    };
    version = "1.2.1";
  };
  hilighter = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-39MPmsO5skkpk8DqU6zijZ79c5eMLuiKVdc1k14i9Q8=";
      type = "gem";
    };
    version = "1.2.3";
  };
  json_config = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-iv9TkygtgR4pDcVEYXszgN4kxXar62bkIfbGYFEwi2o=";
      type = "gem";
    };
    version = "1.1.0";
  };
  ruby-zoom = {
    dependencies = [
      "djinni"
      "fagin"
      "hilighter"
      "json_config"
      "scoobydoo"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gxJTMH+PfE5aT7EP/BnLmq2G0txv27448V1f/zNgHUc=";
      type = "gem";
    };
    version = "5.3.0";
  };
  scoobydoo = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-x6K61pPA8fvn+NJGYguTRj87T9NZt8vwRAf0xGw5V5g=";
      type = "gem";
    };
    version = "1.0.0";
  };
}
