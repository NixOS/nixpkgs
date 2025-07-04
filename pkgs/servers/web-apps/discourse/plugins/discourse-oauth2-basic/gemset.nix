{
  ast = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HigCMuajN1TN5UK8XvhVILdNsqrHPsFKzvRTeERHzBI=";
      type = "gem";
    };
    version = "2.4.2";
  };
  parallel = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-698fDFHxgt84Ui9wuncCFJQL75mM224A82SSspaZdh8=";
      type = "gem";
    };
    version = "1.22.1";
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
      hash = "sha256-bHD9pP04MpxRBaCBjGXg463H75boQaYWlgQLtfeDT30=";
      type = "gem";
    };
    version = "3.1.1.0";
  };
  rainbow = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-A5SRqjqJ9C76HW3sL8TmLt6W62rNleUvGtWBGCt5vGo=";
      type = "gem";
    };
    version = "3.1.1";
  };
  regexp_parser = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lQPNDMumuAizQNOSqF1hEIvB3Sx1tF70KtzlTDIzrpQ=";
      type = "gem";
    };
    version = "2.2.1";
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
      hash = "sha256-9MkbCHoQWWUp+4IUbyFIJPlS5rLhWXcALfVKhbMvIBg=";
      type = "gem";
    };
    version = "1.26.1";
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
      hash = "sha256-mw/RMjKThj3FyXroXD5VUS6zPo9uvxII6tEdTwX6oq0=";
      type = "gem";
    };
    version = "1.16.0";
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
      hash = "sha256-jwBtnkjQ2gdd1H+f99eF1XHEidlPb0S/OQKzVNXxxAU=";
      type = "gem";
    };
    version = "2.5.0";
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
      hash = "sha256-xtkRl/bXmfaMjdAJiwJZzCgVEwJ2NDLwIzsm8m/CLxQ=";
      type = "gem";
    };
    version = "2.9.0";
  };
  ruby-progressbar = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zBJ9s4ZtxBT/zL+SkookHlhbOqK3WKVWPnSm7g9X1Qo=";
      type = "gem";
    };
    version = "1.11.0";
  };
  unicode-display_width = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tv+MMp/b/PZ+Tm3mQro98PXh4Fk1vpoiAzM6CHWqUjM=";
      type = "gem";
    };
    version = "2.1.0";
  };
}
