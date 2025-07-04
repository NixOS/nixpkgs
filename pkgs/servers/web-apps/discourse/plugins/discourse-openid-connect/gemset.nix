{
  ast = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SlSQWgWjroSOxn2Bp5Ylt3uS/rkQkKtGor3K/xkyZNA=";
      type = "gem";
    };
    version = "2.4.1";
  };
  parallel = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-VNwZvviYtwC29RrBoCWw0xBwil4cGxJ+w17U2vsRYZ0=";
      type = "gem";
    };
    version = "1.19.2";
  };
  parser = {
    dependencies = [ "ast" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-39Docv48ozDNu5IiqxTwouJUdJ94NEt5EUNRD0yt77g=";
      type = "gem";
    };
    version = "2.7.2.0";
  };
  rainbow = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-E85P/DyU+3qEIRfsq9zcX/f6J77BXqRBN7n5q+V1Yi0=";
      type = "gem";
    };
    version = "3.0.0";
  };
  regexp_parser = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1iSdRUZL6YcbWIDpbapZi0EOR7U3xDpiON1CfS8JLVk=";
      type = "gem";
    };
    version = "1.8.1";
  };
  rexml = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ozw7+V/aeYPsfwUFTzqYWvQdvCWgM5hDvSR56TyrsSM=";
      type = "gem";
    };
    version = "3.2.5";
  };
  rubocop = {
    dependencies = [
      "parallel"
      "parser"
      "rainbow"
      "regexp_parser"
      "rexml"
      "rubocop-ast"
      "ruby-progressbar"
      "unicode-display_width"
    ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ajxrjlKH6nt8cpq1FAahY6mJT+D5JfBiayqRElA8O9s=";
      type = "gem";
    };
    version = "0.93.0";
  };
  rubocop-ast = {
    dependencies = [ "parser" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5NBMypX14CP+wcPAPj+tBIIJgD+7hBPAAxYxrsl/MIk=";
      type = "gem";
    };
    version = "0.7.1";
  };
  rubocop-discourse = {
    dependencies = [
      "rubocop"
      "rubocop-rspec"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nLooGxauF+5A2oByRaw6CwS+CoO5Q6/xY6yTti3ngoI=";
      type = "gem";
    };
    version = "2.3.2";
  };
  rubocop-rspec = {
    dependencies = [ "rubocop" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-FLaTj9/7zBpG758fxYxSDH9OhXDebf67Xyi73xtfgOk=";
      type = "gem";
    };
    version = "1.43.2";
  };
  ruby-progressbar = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7iNABhX5HCzmvB47+pg5IwLvOMu6itbeG8JqThqI58w=";
      type = "gem";
    };
    version = "1.10.1";
  };
  unicode-display_width = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ytaBBxhnpM9SYTQS43njnoWscrHSNmd6IAEYfUSLIxo=";
      type = "gem";
    };
    version = "1.7.0";
  };
}
