{ opam, ocamlPackages }:

ocamlPackages.buildDunePackage {
  pname = "opam-installer";

  inherit (opam) version src;

  configureFlags = [
    "--disable-checks"
    "--prefix=$out"
  ];
  buildInputs = with ocamlPackages; [
    opam-format
    cmdliner
  ];

  meta = opam.meta // {
    description = "Handle (un)installation from opam install files";
    mainProgram = "opam-installer";
  };
}
