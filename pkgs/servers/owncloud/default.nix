{ stdenv, fetchurl }:
let
  common = { versiona, sha256 } @ args: stdenv.mkDerivation (rec {

    name= "owncloud-${version}";
    version= versiona;

    src = fetchurl {
      url = "https://download.owncloud.org/community/${name}.tar.bz2";
      inherit sha256;
    };

    installPhase =
      ''
        mkdir -p $out
        find . -maxdepth 1 -execdir cp -r '{}' $out \;

        substituteInPlace $out/lib/base.php \
          --replace 'OC_Config::$object = new \OC\Config(self::$configDir);' \
                    'self::$configDir = getenv("OC_CONFIG_PATH"); OC_Config::$object = new \OC\Config(self::$configDir);'
      '';

    meta = {
      description = "An enterprise file sharing solution for online collaboration and storage";
      homepage = https://owncloud.org;
      maintainers = with stdenv.lib.maintainers; [ matejc ];
      license = stdenv.lib.licenses.agpl3Plus;
    };

  });

in {

  owncloud705 = common {
    versiona = "7.0.5";
    sha256 = "1j21b7ljvbhni9l0b1cpzlhsjy36scyas1l1j222mqdg2srfsi9y";
  };

  owncloud70 = common {
    versiona = "7.0.11";
    sha256 = "21dd75de4ed832f16f577eb6763d04c663ef13251153ba2e8847e3f5799d2ad2";
  };

  owncloud80 = common {
    versiona = "8.0.9";
    sha256 = "0c1f915f4123dbe07d564cf0172930568690ab5257d2fca4fec4ec515858bef1";
  };

  owncloud81 = common {
    versiona = "8.1.4";
    sha256 = "e0f4bf0c85821fc1b6e7f6268080ad3ca3e98c41baa68a9d616809d74a77312d";
  };

  owncloud82 = common {
    versiona = "8.2.1";
    sha256 = "5390b2172562a5bf97a46e9a621d1dd92f9b74efaccbb77978c39eb90d6988d4";
  };

}
