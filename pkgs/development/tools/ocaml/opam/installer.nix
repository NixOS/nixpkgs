{ lib, unzip, opam, ocamlPackages, opam-installer, testVersion }:

ocamlPackages.buildDunePackage {
  pname = "opam-installer";

  useDune2 = true;

  inherit (opam) version src;
  nativeBuildInputs = [ unzip ];

  configureFlags = [ "--disable-checks" "--prefix=$out" ];
  buildInputs = with ocamlPackages; [ opam-format cmdliner ];

  passthru.tests.version = testVersion { package = opam-installer; };

  meta = opam.meta // {
    description = "Handle (un)installation from opam install files";
  };
}
