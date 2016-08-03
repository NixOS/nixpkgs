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
      platforms = with stdenv.lib.platforms; unix;
    };

  });

in {

  owncloud705 = common {
    versiona = "7.0.5";
    sha256 = "1j21b7ljvbhni9l0b1cpzlhsjy36scyas1l1j222mqdg2srfsi9y";
  };

  owncloud70 = common {
    versiona = "7.0.12";
    sha256 = "d1a0f73f5094ec1149b50e2409b5fea0a9bebb16d663789d4b8f98fed341aa91";
  };

  owncloud80 = common {
    versiona = "8.0.12";
    sha256 = "04n8r9kya5w1vlib4rbchf0qcl1mrsrrjml9010a9zhh2kajg1g0";
  };

  owncloud81 = common {
    versiona = "8.1.7";
    sha256 = "0xl67axyh7pblsjb1j86vjd8ic42ga1f7yl3ghxy8rk2xrs8cii7";
  };

  owncloud82 = common {
    versiona = "8.2.4";
    sha256 = "03br4lsjz9zxd083lqa0ag3f29224l1ksz59r4fdnnbafj9ixv0s";
  };

  owncloud90 = common {
    versiona = "9.0.2";
    sha256 = "845c43fe981fa0fd07fc3708f41f1ea15ecb11c2a15c65a4de191fc85b237c74";
  };

}
