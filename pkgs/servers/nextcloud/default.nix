{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name= "nextcloud-${version}";
  version = "13.0.6";

  src = fetchurl {
    url = "https://download.nextcloud.com/server/releases/${name}.tar.bz2";
    sha256 = "1m38k5jafz2lniy6fmq17xffkgaqs6rl4w789sqpniva1fb9xz4h";
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
