{
  bigdecimal = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-L/x0IDFSGtacLfyBWpjkJqIwo9Iq6sGZWCanXav62Mw=";
      type = "gem";
    };
    version = "3.1.9";
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
  google-protobuf = {
    dependencies = [
      "bigdecimal"
      "rake"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RCckmsrMsOxNZLxNvVUdFjD5ylDk40vVYB4w51zYQuk=";
      type = "gem";
    };
    version = "4.30.0";
  };
  libusb = {
    dependencies = [
      "ffi"
      "mini_portile2"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WciLzQfOleDwo1k3AGPg9MLBjDrY90oFUHHeqDFfr38=";
      type = "gem";
    };
    version = "0.7.2";
  };
  mini_portile2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jkcTbNrATOgXULtsCXM7N4lb8GliVU5LQFbXgWjXCnU=";
      type = "gem";
    };
    version = "2.8.8";
  };
  nokogiri = {
    dependencies = [
      "mini_portile2"
      "racc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-a5/DsU/Qzt0h9srYz1ZRI7p0AeVrXQrsGAwjzcoo/Vo=";
      type = "gem";
    };
    version = "1.18.3";
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
  rubyserial = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WIjGp6FyQl8GI8Wz/kF73nP000otXbeLm3tlbazyRe4=";
      type = "gem";
    };
    version = "0.6.0";
  };
}
