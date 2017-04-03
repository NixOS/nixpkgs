{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name= "nextcloud-${version}";
  version = "11.0.2";

  src = fetchurl {
    url = "https://download.nextcloud.com/server/releases/${name}.tar.bz2";
    sha256 = "0047kfl73720w7y2r7ivzj2gqg84rcfp98svq130nd0ziyfz27jx";
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
