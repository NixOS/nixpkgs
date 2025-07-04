{
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
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2YfkKy2BF8Rv2dw7HinmgblDVrjCfZte0m1F0baTX2A=";
      type = "gem";
    };
    version = "1.3.6";
  };
  rack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IH5g+RentHy4WKboE1ALxgQqlYwsqe62RjGxnN5wIXM=";
      type = "gem";
    };
    version = "1.6.13";
  };
  rack-protection = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Wp8NVu+WthaiQhOJhtyTCsp29u+iT5mOhoMWRTjlwFc=";
      type = "gem";
    };
    version = "1.5.5";
  };
  rb-fsevent = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Q5ALly5zAdZXD2S4UKWqZ4M+59h7RY7pKAXVa3MYrv4=";
      type = "gem";
    };
    version = "0.11.2";
  };
  rb-inotify = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oKcARBI5sP8Y62XjhmI2zXhhPWufeP6h+axHqF5Hvm4=";
      type = "gem";
    };
    version = "0.11.1";
  };
  riemann-dash = {
    dependencies = [
      "erubis"
      "multi_json"
      "sass"
      "sinatra"
      "webrick"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eTOL+eE9AqoERtAhQipZ6xiytMjuXkMUoaXvsOw0ZsA=";
      type = "gem";
    };
    version = "0.2.14";
  };
  sass = {
    dependencies = [ "sass-listen" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gIsNOQU6ppBo35OeJGcf6E/VqdMxRIbhoUV9CTSkJV0=";
      type = "gem";
    };
    version = "3.7.4";
  };
  sass-listen = {
    dependencies = [
      "rb-fsevent"
      "rb-inotify"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-rp3Ldt0+I0Mp5bpuIT9I5TLFo+ewtNiofxOqygzBg3c=";
      type = "gem";
    };
    version = "4.0.0";
  };
  sinatra = {
    dependencies = [
      "rack"
      "rack-protection"
      "tilt"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GMsg/6vzFISwLYYG5FD78EC1KuphR3VaB3GOng/93S8=";
      type = "gem";
    };
    version = "1.4.8";
  };
  tilt = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Jj10hGbg2D5RCqGi4ige/1R5N/DvBr4z02MnIeJV92s=";
      type = "gem";
    };
    version = "2.6.0";
  };
  webrick = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DylfEron0JigASoNOl3zzWJwqNdiA5wg6EtQBmOvgmg=";
      type = "gem";
    };
    version = "1.3.1";
  };
}
