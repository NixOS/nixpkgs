{
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
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-rp3Ldt0+I0Mp5bpuIT9I5TLFo+ewtNiofxOqygzBg3c=";
      type = "gem";
    };
    version = "4.0.0";
  };
  scss_lint = {
    dependencies = [ "sass" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qtLQ4c3dzYG4FYO1yQoK5WIHG2kToMIAp7/7ejd/N1s=";
      type = "gem";
    };
    version = "0.60.0";
  };
}
