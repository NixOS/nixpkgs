{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name= "nextcloud-${version}";
  version = "12.0.5";

  src = fetchurl {
    url = "https://download.nextcloud.com/server/releases/${name}.tar.bz2";
    sha256 = "0hya524d8wqia5v2wz8cmasi526j97z6d0l1h7l7j442wsn2kgn8";
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
