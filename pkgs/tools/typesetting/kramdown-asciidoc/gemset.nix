{
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
  kramdown-asciidoc = {
    dependencies = [
      "kramdown"
      "kramdown-parser-gfm"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6fJZos1lbPJ/17HBDY2mDuWRKQ+5fDh9cuzBb/Bd+Mg=";
      type = "gem";
    };
    version = "2.1.0";
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
  rexml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4GaaLU6fEJlRyx/ecj2KzShUJdgVlKLqkpMEr1AoKBY=";
      type = "gem";
    };
    version = "3.2.6";
  };
}
