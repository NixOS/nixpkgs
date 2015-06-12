{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "locale-${version}";
  version = "153";

  src = fetchurl {
    url    = "http://opensource.apple.com/tarballs/adv_cmds/adv_cmds-${version}.tar.gz";
    sha256 = "174v6a4zkcm2pafzgdm6kvs48z5f911zl7k49hv7kjq6gm58w99v";
  };

  buildPhase = ''
    cd locale
    c++ -Os -Wall -o locale locale.cc
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1

    cp locale   $out/bin/locale
    cp locale.1 $out/share/man/man1
  '';


  meta = {
    platforms = stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ gridaphobe ];
  };
}
