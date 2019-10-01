{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "nextcloud";
  version = "16.0.5";

  src = fetchurl {
    url = "https://download.nextcloud.com/server/releases/${pname}-${version}.tar.bz2";
    sha256 = "0lg5zaakfdngrh0ida0qbq76jbiab5fv46jziqf77zbnlx7wc2c7";
  };

  installPhase = ''
    mkdir -p $out/
    cp -R . $out/
  '';

  meta = {
    description = "Sharing solution for files, calendars, contacts and more";
    homepage = https://nextcloud.com;
    maintainers = with stdenv.lib.maintainers; [ schneefux bachp globin fpletz ];
    license = stdenv.lib.licenses.agpl3Plus;
    platforms = with stdenv.lib.platforms; unix;
  };
}
