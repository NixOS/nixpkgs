{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name= "nextcloud-${version}";
  version = "11.0.1";

  src = fetchurl {
    url = "https://download.nextcloud.com/server/releases/${name}.tar.bz2";
    sha256 = "0aa6gzcbpjkk7ss3c1sg0scinhczvg4lgb59wv5jljliaks2n5h0";
  };

  installPhase = ''
    mkdir -p $out/
    cp -R . $out/
  '';

  meta = {
    description = "Sharing solution for files, calendars, contacts and more";
    homepage = https://nextcloud.com;
    maintainers = with stdenv.lib.maintainers; [ schneefux ];
    license = stdenv.lib.licenses.agpl3Plus;
    platforms = with stdenv.lib.platforms; unix;
  };
}
