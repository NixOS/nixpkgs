{
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
  compass = {
    dependencies = [
      "chunky_png"
      "compass-core"
      "compass-import-once"
      "rb-fsevent"
      "rb-inotify"
      "sass"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-THiE3FNJ1ZAR/WxXNqBAQAjVYJI1A3dB/qycj/hA0VE=";
      type = "gem";
    };
    version = "1.0.3";
  };
  compass-core = {
    dependencies = [
      "multi_json"
      "sass"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-asi7TKu1v4DRp/67rP01waqD6Rp6URY3Zo3/2ji+Wnk=";
      type = "gem";
    };
    version = "1.0.3";
  };
  compass-import-once = {
    dependencies = [ "sass" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-OJeP/tDTMuhSbofhvv0baDF3TKfYNQxa21ue7xZ/xy4=";
      type = "gem";
    };
    version = "1.0.5";
  };
  ffi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Vs/KUmHq1IaIJBI2rf77B6AAptFxhNek7tSNVblnXWs=";
      type = "gem";
    };
    version = "1.15.4";
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
  rb-fsevent = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-OgK2NgyFbMFuf2I4JXOyOPXPthpIFp3UyDuELAlLXeM=";
      type = "gem";
    };
    version = "0.11.0";
  };
  rb-inotify = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BQBi1PMdMHzKUsP2p/S5Rt+N4l/EvTc+GlFC5BA0p8o=";
      type = "gem";
    };
    version = "0.10.1";
  };
  sass = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-fNJyw5v6OlL7/CaF84aXCZlxqNyTPhwQo4S/hiBn100=";
      type = "gem";
    };
    version = "3.4.25";
  };
}
