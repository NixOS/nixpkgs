{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ps-${version}";
  version = "153";

  src = fetchurl {
    url    = "http://opensource.apple.com/tarballs/adv_cmds/adv_cmds-${version}.tar.gz";
    sha256 = "174v6a4zkcm2pafzgdm6kvs48z5f911zl7k49hv7kjq6gm58w99v";
  };

  buildPhase = ''
    cd ps
    cc -Os -Wall -I. -c -o fmt.o fmt.c
    cc -Os -Wall -I. -c -o keyword.o keyword.c
    cc -Os -Wall -I. -c -o nlist.o nlist.c
    cc -Os -Wall -I. -c -o print.o print.c
    cc -Os -Wall -I. -c -o ps.o ps.c
    cc -Os -Wall -I. -c -o tasks.o tasks.c
    cc -o ps fmt.o keyword.o nlist.o print.o ps.o tasks.o
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1

    cp ps   $out/bin/ps
    cp ps.1 $out/share/man/man1
  '';


  meta = {
    platforms = stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ gridaphobe ];
  };
}
