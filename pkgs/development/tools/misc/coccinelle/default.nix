{ fetchurl, stdenv, python, ncurses, ocamlPackages, pkgconfig }:

stdenv.mkDerivation rec {
  name    = "coccinelle-${version}";
  version = "1.0.6";

  src = fetchurl {
    url = "http://coccinelle.lip6.fr/distrib/${name}.tgz";
    sha256 = "02g9hmwkvfl838zz690yra5jzrqjg6y6ffxkrfcsx790bhkfsll4";
  };

  buildInputs = with ocamlPackages; [
    ocaml findlib menhir
    ocaml_pcre pycaml
    python ncurses pkgconfig
  ];

  doCheck = !stdenv.isDarwin;

  # The build system builds two versions of spgen:
  # 'spgen' with ocamlc -custom (bytecode specially linked)
  # and 'spgen.opt' using ocamlopt.
  # I'm not sure of the intentions here, but the way
  # the 'spgen' binary is produced results in an
  # invalid/incorrect interpreter path (/lib/ld-linux*).
  # We could patch it, but without knowing why it's
  # finding the wrong path it seems safer to use
  # the .opt version that is built correctly.
  # All that said, our fix here is simple: remove 'spgen'.
  # The bin/spgen entrypoint is really a bash script
  # and will use spgen.opt if 'spgen' doesn't exist.
  postInstall = ''
    rm $out/lib/coccinelle/spgen/spgen
  '';

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
