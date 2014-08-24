{ fetchurl, stdenv, python, ncurses, ocamlPackages, pkgconfig, makeWrapper }:

let

  name = "coccinelle-1.0.0-rc15";
  sha256 = "07fab4e17512925b958890bb13c0809797074f2e44a1107b0074bdcc156b9596";

in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://coccinelle.lip6.fr/distrib/${name}.tgz";
    inherit sha256;
  };

  buildInputs = with ocamlPackages; [
    ocaml findlib menhir
    ocaml_pcre pycaml
    python ncurses pkgconfig
    makeWrapper
  ];

  # TODO: is the generation of this wrapper truly/still needed?
  # I don't have a non-NixOS system, so I cannot verify this, but shouldn't
  # libpython know where to find its modules? (the path is for example in
  # its Sys-module).
  postInstall =
    # On non-NixOS systems, Coccinelle would end up looking up Python modules
    # in the wrong directory.
    '' for p in "$out/bin/"*
       do
         wrapProgram "$p" \
           --prefix "PYTHONPATH" ":" "${python}/lib/python${python.majorVersion}"
       done
    '';

  configureFlags = "--enable-release";

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
    license = stdenv.lib.licenses.gpl2;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
