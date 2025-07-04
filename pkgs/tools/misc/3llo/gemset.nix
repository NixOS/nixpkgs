{
  "3llo" = {
    dependencies = [ "tty-prompt" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YspzebDNb+bzr7zMfBENM02TAze+Y7xywpcK9aY+YvA=";
      type = "gem";
    };
    version = "1.3.1";
  };
  pastel = {
    dependencies = [ "tty-color" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SB2p+30vbmsaCPrxH6EDYxctxA/UeEjwlq4hIJ+AWnU=";
      type = "gem";
    };
    version = "0.8.0";
  };
  tty-color = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-b5w3yjpOI2f7Lm0JcidiZH1vRVwRHwW1nzVzDuskMyo=";
      type = "gem";
    };
    version = "0.6.0";
  };
  tty-cursor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eVNBheand4iNiGKLFLah/fUVSmA/KF+AsXU+GQjgv0g=";
      type = "gem";
    };
    version = "0.7.1";
  };
  tty-prompt = {
    dependencies = [
      "pastel"
      "tty-reader"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/NvOkFI4mT8n7s/fZ1l6Y2vIOdkhkvag7vIrgWZEnsg=";
      type = "gem";
    };
    version = "0.23.1";
  };
  tty-reader = {
    dependencies = [
      "tty-cursor"
      "tty-screen"
      "wisper"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xilyyYXAsVZvDlZ0O2p4gvl509wy/0ke1JCgdviZwrE=";
      type = "gem";
    };
    version = "0.9.0";
  };
  tty-screen = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZQhlfDjzK9ymSICr4gHOI32AyUFG4fm5Ecujx4I2WaI=";
      type = "gem";
    };
    version = "0.8.1";
  };
  wisper = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zhe8XDoWbyQaLmYThIsCXIFG/OLe+6UFkgwdHz+I+uY=";
      type = "gem";
    };
    version = "2.0.1";
  };
}
