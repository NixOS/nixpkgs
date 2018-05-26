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

  owncloud70 = common {
    versiona = "7.0.15";
    sha256 = "1b2a0fccxlkqyyzsymx7qw8qbhsks3i6h1ybvxv8nn8hgw33nqv7";
  };

  owncloud80 = common {
    versiona = "8.0.16";
    sha256 = "1pgfawrmx6n02h7h6g5wk0sa1kgablqa8ljfiywyw8znxxa5lnrm";
  };

  owncloud81 = common {
    versiona = "8.1.11";
    sha256 = "04izfzj3ckcs0x882kkggp6y7zcrhdihm71wkd9vk6j5fn8k9am0";
  };

  owncloud82 = common {
    versiona = "8.2.9";
    sha256 = "09gzpxd9gjg8h57m8j0r6xnr85fdb951ykwmjby811c6730769pw";
  };

  owncloud90 = common {
    versiona = "9.0.7";
    sha256 = "1j6xrd4dhc0v0maa3z8n392nfc9hrnvbxxyqr8g8kz88w9vbqa6h";
  };

  owncloud91 = common {
    versiona = "9.1.3";
    sha256 = "1sgnsj2ng14lh05n5kc3jv03xk6xnkyx7xj1rasxlqgvzwsyp8g0";
  };

}
