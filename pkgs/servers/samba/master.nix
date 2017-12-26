{ lib, stdenv, fetchFromGitHub
, samba4
, nettle
} :

  (samba4.overrideAttrs(oldAttrs: rec {
    name = "samba-master${version}";
    version = "4.8_2017-12-25";

    src = fetchFromGitHub {
      owner = "samba-team";
      repo = "samba";
      rev = "8a42954775df6795efa9b5ba5676301d14b3efac";
      sha256 = "19pdnvs23ny8cbfd119dqv8mc1qbay6c2ibsn0imc9cnl4wdzqdg";
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
