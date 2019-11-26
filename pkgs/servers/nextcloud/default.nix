{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "nextcloud";
  version = "17.0.1";

  src = fetchurl {
    url = "https://download.nextcloud.com/server/releases/${pname}-${version}.tar.bz2";
    sha256 = "0jrbpzc4xf52zfncn6w2m0ch2fszqqz3ny0jq1cw7fy24vjhwgkp";
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
