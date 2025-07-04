{
  chef-utils = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-g5OXQl7TZON1csKvIOQ1sGMWw8vsQbez1+FoNlS2azI=";
      type = "gem";
    };
    version = "18.1.0";
  };
  concurrent-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-peeZ9x50kPJKU01YyROAJn0K4wavDNxRjWhIuTR12uI=";
      type = "gem";
    };
    version = "1.2.0";
  };
  kramdown = {
    dependencies = [ "rexml" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ti5by9bqIMemcw67sqEHI3hW4U8pzr9bEMh2zBokgcU=";
      type = "gem";
    };
    version = "2.4.0";
  };
  kramdown-parser-gfm = {
    dependencies = [ "kramdown" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+zl0VRZCfSmIVDvwH8TPCrEUlHY4I5Pg6cSFkvZYFyk=";
      type = "gem";
    };
    version = "1.1.0";
  };
  mdl = {
    dependencies = [
      "kramdown"
      "kramdown-parser-gfm"
      "mixlib-cli"
      "mixlib-config"
      "mixlib-shellout"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IHpeJqTE4ZCVs5vgIBg0pp0x2DiYKlfro0ORjbochqg=";
      type = "gem";
    };
    version = "0.13.0";
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
  mixlib-shellout = {
    dependencies = [ "chef-utils" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RvbR+cd+aJpEMIHFysM2IDND8PIiTbBrgNOa5M15fH4=";
      type = "gem";
    };
    version = "3.2.7";
  };
  rexml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ozw7+V/aeYPsfwUFTzqYWvQdvCWgM5hDvSR56TyrsSM=";
      type = "gem";
    };
    version = "3.2.5";
  };
  tomlrb = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-wnNqzySRn3kzNAI6T/OWwGR9k/znAqc8nTSN6qgV1Pc=";
      type = "gem";
    };
    version = "2.0.3";
  };
}
