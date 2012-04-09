{ fetchurl, stdenv, python, ncurses, ocamlPackages }:

let

  name = "coccinelle-1.0.0-rc12";
  sha256 = "03b8930a53623ec79dc2486e9b6a569e373958cf46074c5f1d0028c70708498d";

in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://coccinelle.lip6.fr/distrib/${name}.tgz";
    inherit sha256;
  };

  buildInputs = with ocamlPackages; [
    ocaml findlib menhir
    ocaml_pcre ocaml_sexplib pycaml
    python ncurses
  ];

  configureFlagsArray = [ "--enable-release" ];

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
