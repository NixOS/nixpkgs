{ stdenv
, lib
, fetchFromGitHub
, ocamlPackages
, pkg-config
, autoreconfHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "coccinelle";
  version = "1.2";

  src = fetchFromGitHub {
    repo = "coccinelle";
    rev = finalAttrs.version;
    owner = "coccinelle";
    hash = "sha256-v51KQLMJENLrlstCsP3DAuJJFMyjFyOZPJ7cRW5ovws=";
  };

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
})
