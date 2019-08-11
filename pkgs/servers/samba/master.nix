{ fetchFromGitHub
, samba4
, nettle
} :

  (samba4.overrideAttrs(oldAttrs: rec {
    name = "samba-unstable-${version}";
    version = "2018-03-09";

    src = fetchFromGitHub {
      owner = "samba-team";
      repo = "samba";
      rev = "9e954bcbf43d67a18ee55f84cda0b09028f96b92";
      sha256 = "07j1pwm4kax6pq21gq9gpmp7dhj5afdyvkhgyl3yz334mb41q11g";
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
