{ stdenv, appleDerivation, version }:

appleDerivation {
  # Will override the name until we provide all of adv_cmds
  buildPhase = ''
    pushd ps
    cc -Os -Wall -I. -c -o fmt.o fmt.c
    cc -Os -Wall -I. -c -o keyword.o keyword.c
    cc -Os -Wall -I. -c -o nlist.o nlist.c
    cc -Os -Wall -I. -c -o print.o print.c
    cc -Os -Wall -I. -c -o ps.o ps.c
    cc -Os -Wall -I. -c -o tasks.o tasks.c
    cc -o ps fmt.o keyword.o nlist.o print.o ps.o tasks.o
    popd

    pushd locale
    c++ -o locale locale.cc
    popd
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1

    cp ps/ps   $out/bin/ps
    cp ps/ps.1 $out/share/man/man1
    cp locale/locale   $out/bin/locale
    cp locale/locale.1 $out/share/man/man1
  '';


  meta = {
    platforms = stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ gridaphobe ];
  };
}
