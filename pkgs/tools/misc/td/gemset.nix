{
  fluent-logger = {
    dependencies = [ "msgpack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-K/5NIj9Q+FpeOXNsoFsrkmPqIoCws0FYNWhZCfgLjOI=";
      type = "gem";
    };
    version = "0.9.1";
  };
  hirb = {
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UTJzPKRLH0HzbGJGk6MgEoQ2ijSd/jf1Q65uKtiA7Fc=";
      type = "gem";
    };
    version = "0.7.3";
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
  msgpack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5kzgISAA0BaAn1BItI6zpl/7Fp2yIjj7S3JHL+yy1zI=";
      type = "gem";
    };
    version = "1.8.0";
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
  parallel = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7U+uxEmL+SHhCshoPtWEDZHi8wfCb44k+NiuWEFepQA=";
      type = "gem";
    };
    version = "1.20.1";
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
  rubyzip = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-FJ3ZA4bF7vg3NTshzZoM/U7FoHskqxj3NPVGzvsXrOM=";
      type = "gem";
    };
    version = "1.3.0";
  };
  td = {
    dependencies = [
      "hirb"
      "msgpack"
      "parallel"
      "rexml"
      "ruby-progressbar"
      "rubyzip"
      "td-client"
      "td-logger"
      "yajl-ruby"
      "zip-zip"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4uj4miqrkoYRKT1Eg2XxNaxxoC8Z81Mi3hpYn75I4dE=";
      type = "gem";
    };
    version = "0.17.1";
  };
  td-client = {
    dependencies = [
      "httpclient"
      "msgpack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-B/wXC7WyqEhcp8+kufeGeoS5CiNiMUxbvl1JY1rfDSA=";
      type = "gem";
    };
    version = "1.0.8";
  };
  td-logger = {
    dependencies = [
      "fluent-logger"
      "msgpack"
      "td-client"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-e5A3lBhfzOdqZBUUcgUvNsHgLaAGc1fh/nvBxzDit4o=";
      type = "gem";
    };
    version = "0.3.28";
  };
  yajl-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jJdNnBGuB7CjttJu/qhAcmmwLkE4EY++PvDS7Jck0dI=";
      type = "gem";
    };
    version = "1.4.3";
  };
  zip-zip = {
    dependencies = [ "rubyzip" ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-D2/1v+N5Jyl9fG8i78o83OjXzzpvuumr0oonq8P+w1s=";
      type = "gem";
    };
    version = "0.3";
  };
}
