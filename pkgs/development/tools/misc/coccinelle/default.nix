{ fetchurl, lib, stdenv, python3, ncurses, ocamlPackages, pkg-config }:

stdenv.mkDerivation rec {
  pname = "coccinelle";
  version = "1.1.0";

  src = fetchurl {
    url = "https://coccinelle.gitlabpages.inria.fr/website/distrib/${pname}-${version}.tar.gz";
    sha256 = "0k0x4qnxzj8fymkp6y9irggcah070hj7hxq8l6ddj8ccpmjbhnsb";
  };

  buildInputs = with ocamlPackages; [
    ocaml findlib menhir
    ocaml_pcre parmap stdcompat
    python3 ncurses pkg-config
  ];

  doCheck = false;

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

    homepage = "http://coccinelle.lip6.fr/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
