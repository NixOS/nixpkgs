{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "nextcloud";
  version = "16.0.8";

  src = fetchurl {
    url = "https://download.nextcloud.com/server/releases/${pname}-${version}.tar.bz2";
    sha256 = "0c5z46936pxsmh5isgj5d8pcj1sy9hcqdi55awz5axs7h5cvabr5";
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
