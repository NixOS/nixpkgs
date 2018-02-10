{ lib, stdenv, fetchFromGitHub
, samba4
, nettle
} :

  (samba4.overrideAttrs(oldAttrs: rec {
    name = "samba-master${version}";
    version = "4.8.0_2018-01-25";

    src = fetchFromGitHub {
      owner = "samba-team";
      repo = "samba";
      rev = "849169a7b6ed0beb78bbddf25537521c1ed2f8e1";
      sha256 = "1535w787cy1x5ia9arjrg6hhf926wi8wm9qj0k0jgydy3600zpbv";
    };

    # Remove unnecessary install flags, same as <4.8 patch
    postPatch = oldAttrs.postPatch + ''
      sed -i '423,433d' dynconfig/wscript
    '';

    patches = [ ./4.x-no-persistent-install.patch ];
    buildInputs = [ nettle ] ++ oldAttrs.buildInputs;
    meta.branch = "master";
  })).override {
    # samba4.8+ removed the ability to disable LDAP.
    # Enable for base derivation here:
    enableLDAP = true;
  }
