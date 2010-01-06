{ fetchurl, stdenv, ocaml, perl, python, ncurses, makeWrapper }:

stdenv.mkDerivation rec {
  name = "coccinelle-0.2.0rc1";

  src = fetchurl {
    url = "http://coccinelle.lip6.fr/distrib/${name}.tgz";
    sha256 = "06mfxhgqh52ak7bm3bj0nvi56k6gjqlf1iv00jci6nw3d083pw3j";
  };

  buildInputs = [ ocaml perl python ncurses makeWrapper ];

  preConfigure =
    '' sed -i "configure" -e's|/usr/bin/perl|${perl}/bin/perl|g'
       sed -i "globals/config.ml.in" \
           -e"s|/usr/local/share|$out/share|g"
    '';

  buildPhase = "make depend && make all";

  # Most of the test suite seems to fail (?!).
  doCheck = false;
  checkPhase = "make test";

  postInstall =
    '' wrapProgram "$out/bin/spatch"                                    \
         --prefix "LD_LIBRARY_PATH" ":" "$out/lib"                      \
         --prefix "PYTHONPATH" ":" "$out/share/coccinelle/python"
    '';

  meta = {
    description = "Coccinelle, a program to apply C code semantic patches";

    longDescription =
      '' Coccinelle is a program matching and transformation engine which
         provides the language SmPL (Semantic Patch Language) for specifying
         desired matches and transformations in C code.  Coccinelle was
         initially targeted towards performing collateral evolutions in
         Linux.  Such evolutions comprise the changes that are needed in
         client code in response to evolutions in library APIs, and may
         include modifications such as renaming a function, adding a function
         argument whose value is somehow context-dependent, and reorganizing
         a data structure.  Beyond collateral evolutions, Coccinelle is
         successfully used (by us and others) for finding and fixing bugs in
         systems code.
      '';

    homepage = http://coccinelle.lip6.fr/;
    license = "GPLv2";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
