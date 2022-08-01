{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, ocamlPackages
, pkg-config
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "coccinelle";
  version = "1.1.1";

  src = fetchFromGitHub {
    repo = pname;
    rev = version;
    owner = "coccinelle";
    hash = "sha256-rS9Ktp/YcXF0xUtT4XZtH5F9huvde0vRztY7vGtyuqY=";
  };

  patches = [
    # Fix data path lookup.
    # https://github.com/coccinelle/coccinelle/pull/270
    (fetchpatch {
      url = "https://github.com/coccinelle/coccinelle/commit/540888ff426e0b1f7907b63ce26e712d1fc172cc.patch";
      sha256 = "sha256-W8RNIWDAC3lQ5bG+gD50r7x919JIcZRpt3QSOSMWpW4=";
    })
  ];

  nativeBuildInputs = with ocamlPackages; [
    autoreconfHook
    pkg-config
    ocaml
    findlib
    menhir
  ];

  buildInputs = with ocamlPackages; [
    ocaml_pcre
    parmap
    pyml
    stdcompat
  ];

  strictDeps = true;

  postPatch = ''
    # Ensure dependencies from Nixpkgs are picked up.
    rm -rf bundles/
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

    homepage = "https://coccinelle.gitlabpages.inria.fr/website/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
