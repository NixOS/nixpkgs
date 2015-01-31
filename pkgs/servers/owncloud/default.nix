{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name= "owncloud-${version}";
  version = "7.0.4";

  src = fetchurl {
    url = "https://download.owncloud.org/community/${name}.tar.bz2";
    sha256 = "0djgqdyxkrh1wc4sn21fmdjr09dkmnjm3gs6lbkp6yn5fpbzhybi";
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
