{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "nextcloud-${version}";
  version = "16.0.3";

  src = fetchurl {
    url = "https://download.nextcloud.com/server/releases/${name}.tar.bz2";
    sha256 = "1ww1517i05gaf71szx0qpdc87aczllcb39cvc8c26dm18z76hgx1";
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
