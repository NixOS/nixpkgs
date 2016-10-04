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
    versiona = "7.0.15";
    sha256 = "1b2a0fccxlkqyyzsymx7qw8qbhsks3i6h1ybvxv8nn8hgw33nqv7";
  };

  owncloud80 = common {
    versiona = "8.0.15";
    sha256 = "18042jkp4p3b6xh394zm80126975g94r4ka8gzwhyvgfwpgxrx84";
  };

  owncloud81 = common {
    versiona = "8.1.10";
    sha256 = "1vspsd3l86mrhhddmyafwdr961f4dy6ln2j4dds2h45wf6296c63";
  };

  owncloud82 = common {
    versiona = "8.2.8";
    sha256 = "0k10b3gfpfk3imxhkra0vn6a004xmcma09lw6pgxnalpmpbm8jiy";
  };

  owncloud90 = common {
    versiona = "9.0.5";
    sha256 = "1igpjc4rfaxqrkf2dln85wvdii54nrmwlh17fq3g0232l3vw9hn8";
  };

  owncloud91 = common {
    versiona = "9.1.1";
    sha256 = "1fd73ggzj2v43j284is2c6936gwkmz1inr5fm88rmq5pxcqkbgx6";
  };

}
