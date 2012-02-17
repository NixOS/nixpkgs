{ fetchurl, stdenv, perl, python, ncurses, makeWrapper
, ocaml, ocamlPackages }:

stdenv.mkDerivation rec {
  name = "coccinelle-1.0.0-rc9";

  src = fetchurl {
    url = "http://coccinelle.lip6.fr/distrib/${name}.tgz";
    sha256 = "75d5354e76500b627ccc33b8a929305e5a815ebf08027a8dc094f75ece241697";
  };

  buildInputs = [
      ocaml ocamlPackages.findlib
      ocamlPackages.menhir ocamlPackages.ocaml_batteries
      ocamlPackages.ocaml_pcre ocamlPackages.ocaml_sexplib
      ocamlPackages.ocaml_extlib ocamlPackages.pycaml
      python ncurses makeWrapper perl
    ];

  preConfigure =
    '' sed -i "configure" -e's|/usr/bin/perl|${perl}/bin/perl|g'
       sed -i "globals/config.ml.in" \
           -e"s|/usr/local/share|$out/share|g"
    '';

  buildPhase = "make depend && make all && make all.opt";

  # Note: The tests want $out/share/coccinelle/standard.h so they must be run
  # after "make install".
  doCheck = false;

  postInstall =
    '' wrapProgram "$out/bin/spatch"                                    \
         --prefix "LD_LIBRARY_PATH" ":" "$out/lib"                      \
         --prefix "PYTHONPATH" ":" "$out/share/coccinelle/python"

       wrapProgram "$out/bin/spatch.opt"                                \
         --prefix "LD_LIBRARY_PATH" ":" "$out/lib"                      \
         --prefix "PYTHONPATH" ":" "$out/share/coccinelle/python"

       yes | make test
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
