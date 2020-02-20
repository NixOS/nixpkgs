{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "nextcloud";
  version = "18.0.1";

  src = fetchurl {
    url = "https://download.nextcloud.com/server/releases/${pname}-${version}.tar.bz2";
    sha256 = "1h0rxpdssn1hc65k41zbvww9r4f79vbd9bixc9ri5n7hp0say3vp";
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
