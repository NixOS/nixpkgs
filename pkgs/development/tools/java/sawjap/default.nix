{ stdenv, ocamlPackages }:

let inherit (ocamlPackages) ocaml findlib sawja; in

stdenv.mkDerivation {

  pname = "sawjap";

  inherit (sawja) src version;

  prePatch = "cd test";

  strictDeps = true;

  nativeBuildInputs = [ ocaml findlib ];
  buildInputs = [ sawja ];

  buildPhase = ''
    runHook preBuild
    mkdir -p $out/bin
    ocamlfind opt -o $out/bin/sawjap -package sawja -linkpkg sawjap.ml
    runHook postBuild
  '';

  dontInstall = true;

  meta = sawja.meta // {
    description = "Pretty-print .class files";
  };

}
