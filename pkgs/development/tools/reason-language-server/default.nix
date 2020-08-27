{ stdenv, fetchFromGitHub, buildDunePackage, ocamlPackages, reason }:

let compatibleReason = reason.override { inherit ocamlPackages; };
in
buildDunePackage rec {
  pname = "reason-language-server";
  version = "1.7.8";

  buildInputs = with ocamlPackages; [ ocaml-migrate-parsetree compatibleReason uri ];

  src = fetchFromGitHub {
    owner = "jaredly";
    repo = "reason-language-server";
    rev = "${version}";
    sha256 = "03l4fpqli6ma6nkhi168lizvd9nr1m4kbfqbmkwir6z67d51ybm9";
  };

  preConfigure = ''
    # manually disable tests
    rm test/dune util_tests/dune
  '';

  installPhase = ''
    install -D _build/default/bin/Bin.exe $out/bin/reason-language-server
  '';
}
