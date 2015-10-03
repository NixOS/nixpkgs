{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name= "owncloud-${version}";
  version = "7.0.5";

  src = fetchurl {
    url = "https://download.owncloud.org/community/${name}.tar.bz2";
    sha256 = "1j21b7ljvbhni9l0b1cpzlhsjy36scyas1l1j222mqdg2srfsi9y";
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

}
