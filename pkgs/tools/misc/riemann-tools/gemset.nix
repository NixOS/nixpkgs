{
  beefcake = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+wFh9h1Gp9DYI5XVJlyop23sXscTR1nxgJS2exRo8YE=";
      type = "gem";
    };
    version = "1.0.0";
  };
  json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Za8nyphfcOsNCDqrD3VxLHcYcSIq8CHOUzutd707smI=";
      type = "gem";
    };
    version = "1.8.6";
  };
  mtrc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-P1b8h9O1l88Z4BAF54zGD/LvurZRo8F7aArYy8i+QnY=";
      type = "gem";
    };
    version = "0.0.4";
  };
  optimist = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kki2O+ZO4VFvLhodmNhShXHrKkg5nhkYjbHYZcfNXRY=";
      type = "gem";
    };
    version = "3.0.0";
  };
  riemann-client = {
    dependencies = [
      "beefcake"
      "mtrc"
      "trollop"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KLoRvSv3zsrrH6lO9IZ5b3sv6uMTsdQr6sFA5EVHNws=";
      type = "gem";
    };
    version = "0.2.6";
  };
  riemann-tools = {
    dependencies = [
      "json"
      "optimist"
      "riemann-client"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XfJiTT/01EKy9piuoClG54Rtgd3D0FT1v/yLwePoiR8=";
      type = "gem";
    };
    version = "0.2.14";
  };
  trollop = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5No7KcCEryncDYAtu7oCMfw+6FXl71doC2+Koy09kBw=";
      type = "gem";
    };
    version = "2.9.9";
  };
}
