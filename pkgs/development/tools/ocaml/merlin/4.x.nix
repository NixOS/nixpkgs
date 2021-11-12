{ lib
, substituteAll
, fetchurl
, ocaml
, dune_2
, buildDunePackage
, yojson
, csexp
, result
, dot-merlin-reader
, jq
, menhir
, menhirLib
, menhirSdk
}:

let
  merlinVersion = "4.3.1";

  hashes = {
    "4.3.1-411" = "0lhxkd1wa8k3fkcnhvzlahx3g519cdi5h7lgs60khqqm8nfvfcr5";
    "4.3.1-412" = "0ah2zbj1hhrrfxp4nhfh47jsbkvm0b30dr7ikjpmvb13wa8h20sr";
  };

  ocamlVersionShorthand = lib.concatStrings
    (lib.take 2 (lib.splitVersion ocaml.version));

  version = "${merlinVersion}-${ocamlVersionShorthand}";
in

if !lib.hasAttr version hashes
then builtins.throw "merlin ${merlinVersion} is not available for OCaml ${ocaml.version}"
else

buildDunePackage {
  pname = "merlin";
  inherit version;

  src = fetchurl {
    url = "https://github.com/ocaml/merlin/releases/download/v${version}/merlin-v${version}.tbz";
    sha256 = hashes."${version}";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      dot_merlin_reader = "${dot-merlin-reader}/bin/dot-merlin-reader";
      dune = "${dune_2}/bin/dune";
    })
    # This fixes the test-suite on macOS
    # See https://github.com/ocaml/merlin/pull/1399
    ./test.patch
  ];

  useDune2 = true;

  buildInputs = [
    dot-merlin-reader
    yojson
    csexp
    result
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    patchShebangs tests/merlin-wrapper
    dune runtest # filtering with -p disables tests
    runHook postCheck
  '';
  checkInputs = [
    jq
    menhir
    menhirLib
    menhirSdk
  ];

  meta = with lib; {
    description = "An editor-independent tool to ease the development of programs in OCaml";
    homepage = "https://github.com/ocaml/merlin";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl maintainers.sternenseemann ];
  };
}
