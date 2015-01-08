{ fetchurl, stdenv, python, ncurses, ocamlPackages, pkgconfig, makeWrapper }:

stdenv.mkDerivation rec {
  name    = "coccinelle-${version}";
  version = "1.0.0-rc23";

  src = fetchurl {
    url = "http://coccinelle.lip6.fr/distrib/${name}.tgz";
    sha256 = "1qrd4kr3wc0hm4l60fwn19iwzwqcjsx85mm3k4gm3cdhljjma82p";
  };

  buildInputs = with ocamlPackages; [
    ocaml findlib menhir ocamlPackages.camlp4
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
    description = "Program to apply semantic patches to C code";
    longDescription = ''
      Coccinelle is a program matching and transformation engine which
      provides the language SmPL (Semantic Patch Language) for
      specifying desired matches and transformations in C code.
      Coccinelle was initially targeted towards performing collateral
      evolutions in Linux.  Such evolutions comprise the changes that
      are needed in client code in response to evolutions in library
      APIs, and may include modifications such as renaming a function,
      adding a function argument whose value is somehow
      context-dependent, and reorganizing a data structure.  Beyond
      collateral evolutions, Coccinelle is successfully used (by us
      and others) for finding and fixing bugs in systems code.
    '';

    homepage = http://coccinelle.lip6.fr/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
