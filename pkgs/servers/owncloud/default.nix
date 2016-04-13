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
    versiona = "7.0.12";
    sha256 = "d1a0f73f5094ec1149b50e2409b5fea0a9bebb16d663789d4b8f98fed341aa91";
  };

  owncloud80 = common {
    versiona = "8.0.10";
    sha256 = "3054b997f258178b57efc526e14384829ac8ab94757191f2d03c13fcb0a3cd93";
  };

  owncloud81 = common {
    versiona = "8.1.5";
    sha256 = "6d8687e40af32c5ca5adfea3fee556ed987b77ad15a1ead5d40cc87a8b76f4b4";
  };

  owncloud82 = common {
    versiona = "8.2.2";
    sha256 = "d5b935f904744b8b40b310f19679702387c852498d0dc7aaeda4555a3db9ad5b";
  };

  owncloud90 = common {
    versiona = "9.0.0";
    sha256 = "0z57lc6z1h7yn1sa26q8qnhjxyjn0ydy3mf4yy4i9a3p198kfryi";
  };

}
