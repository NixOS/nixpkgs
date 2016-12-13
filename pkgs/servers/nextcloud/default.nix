{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name= "nextcloud-${version}";
  version = "10.0.2";

  src = fetchurl {
    url = "https://download.nextcloud.com/server/releases/${name}.tar.bz2";
    sha256 = "0g0h6yyy712mpyqzxa9azqlkgiw9hplv88xv0r7lh4w4fwcai1x6";
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
