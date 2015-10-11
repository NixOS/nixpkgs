{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name= "owncloud-${version}";
  version = "8.1.0";

  src = fetchurl {
    url = "https://download.owncloud.org/community/${name}.tar.bz2";
    sha256 = "1vkly4xv1wdswvjss8pr6vxvfrmvsk663r6xpygwm0vh7lxqsc1x";
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
