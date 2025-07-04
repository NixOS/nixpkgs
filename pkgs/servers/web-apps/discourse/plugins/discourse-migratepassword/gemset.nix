{
  argon2 = {
    dependencies = [
      "ffi"
      "ffi-compiler"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jT+DbLLD6X/kgi+daw6JugNjbtiNFkSc/zagTDGjtPE=";
      type = "gem";
    };
    version = "2.2.0";
  };
  bcrypt = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-l2oa/CsQ54y4AX/7dlgzYahn701g1liFWMCOJ0uoICo=";
      type = "gem";
    };
    version = "3.1.13";
  };
  ffi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UWMOQ0JQeDEcBWynX5Ybs72hZBqzbkStTEVeCw5KIxw=";
      type = "gem";
    };
    version = "1.17.0";
  };
  ffi-compiler = {
    dependencies = [
      "ffi"
      "rake"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-AZ84mweKL+yd5/T2V3EJX4CkR+NENrRYi8tinipWTDA=";
      type = "gem";
    };
    version = "1.0.1";
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
  unix-crypt = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uD1RvsDz/ox/ftJcA+cZY6XQCa03XRrxfpXFWvWN1PE=";
      type = "gem";
    };
    version = "1.3.0";
  };
}
