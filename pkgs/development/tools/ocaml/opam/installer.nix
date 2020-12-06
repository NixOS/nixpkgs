{ lib, unzip, opam, ocamlPackages }:

ocamlPackages.buildDunePackage {
  pname = "opam-installer";

  useDune2 = true;

  inherit (opam) version src;
  nativeBuildInputs = [ unzip ];

  configureFlags = [ "--disable-checks" "--prefix=$out" ];
  buildInputs = with ocamlPackages; [ opam-format cmdliner ];

  meta = opam.meta // {
    description = "Handle (un)installation from opam install files";
  };
}
