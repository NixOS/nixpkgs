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
  merlinVersion = "4.1";

  hashes = {
    "4.1-411" = "9e2e6fc799c93ce1f2c7181645eafa37f64e43ace062b69218e1c29ac459937d";
    "4.1-412" = "fb4caede73bdb8393bd60e31792af74b901ae2d319ac2f2a2252c694d2069d8d";
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
