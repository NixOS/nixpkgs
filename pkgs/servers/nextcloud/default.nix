{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nextcloud-${version}";
  version = "14.0.0";

  src = fetchurl {
    url = "https://download.nextcloud.com/server/releases/${name}.tar.bz2";
    sha256 = "0iwg7g2ydrs0ah5hxl9m5hqaz5wmymmdhiy997zbpap7hr1c2rgr";
  };

  installPhase = ''
    mkdir -p $out/
    cp -R . $out/
  '';

  meta = {
    description = "Sharing solution for files, calendars, contacts and more";
    homepage = https://nextcloud.com;
    maintainers = with stdenv.lib.maintainers; [ schneefux bachp ];
    license = stdenv.lib.licenses.agpl3Plus;
    platforms = with stdenv.lib.platforms; unix;
  };
}
