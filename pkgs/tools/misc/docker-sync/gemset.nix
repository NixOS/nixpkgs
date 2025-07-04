{
  backticks = {
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RfPZ9Ng/C15MgFIire7emo9pK4MZ25tWtltNthNFIu8=";
      type = "gem";
    };
    version = "1.0.2";
  };
  daemons = {
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nLh7cppFDFVCsLjylUXdmv0kA7k1TOAcVueRtkdUr1A=";
      type = "gem";
    };
    version = "1.3.1";
  };
  docker-compose = {
    dependencies = [ "backticks" ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7IXz3k21VhiHjwcKrz1EfIPC4M43hkQbGfjWLFDwYwM=";
      type = "gem";
    };
    version = "1.1.10";
  };
  docker-sync = {
    dependencies = [
      "daemons"
      "docker-compose"
      "dotenv"
      "gem_update_checker"
      "os"
      "terminal-notifier"
      "thor"
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-D0s2bMLaC2g1NZcmXM89j5PuiblDOHMWGBzNI99jNO8=";
      type = "gem";
    };
    version = "0.5.9";
  };
  dotenv = {
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DuX+YqLTVEcmVwvQC6JHP2AVRVl75ZXilgt3C/EU9GU=";
      type = "gem";
    };
    version = "2.6.0";
  };
  gem_update_checker = {
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pw9cYc+sQ72L+51pfgt5HKgWva4MWDTCnjMVPDD5azI=";
      type = "gem";
    };
    version = "0.2.0";
  };
  os = {
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-M4fsLHNX3zY/N2eSFQHjweteCxAqDgIhykI/DPcLgOg=";
      type = "gem";
    };
    version = "1.0.0";
  };
  terminal-notifier = {
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eg0rIhKrmDXAf0suIqlM/2QUnboe7SA8BINfeZEHjOo=";
      type = "gem";
    };
    version = "2.0.0";
  };
  thor = {
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Sbwhf+KPavNMbmCwA+NAXCdZWlVokHfYLp5h1NO1Gfo=";
      type = "gem";
    };
    version = "0.20.3";
  };
}
