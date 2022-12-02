{ lib
, substituteAll
, fetchurl
, ocaml
, dune_2
, buildDunePackage
, yojson
, csexp
, merlin-lib
, dot-merlin-reader
, jq
, menhir
, menhirLib
, menhirSdk
}:

let
  merlinVersion = "4.6";

  hashes = {
    "4.6-412" = "sha256-isiurLeWminJQQR4oHpJPCzVk6cEmtQdX4+n3Pdka5c=";
    "4.6-413" = "sha256-8903H4TE6F/v2Kw1XpcpdXEiLIdb9llYgt42zSR9kO4=";
    "4.6-414" = "sha256-AuvXCjx32JQBY9vkxAd0pEjtFF6oTgrT1f9TJEEDk84=";
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
    url = "https://github.com/ocaml/merlin/releases/download/v${version}/merlin-${version}.tbz";
    sha256 = hashes."${version}";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      dot_merlin_reader = "${dot-merlin-reader}/bin/dot-merlin-reader";
      dune = "${dune_2}/bin/dune";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    menhir
    jq
  ];
  buildInputs = [
    dot-merlin-reader
    yojson
    (if lib.versionAtLeast version "4.6-414"
     then merlin-lib
     else csexp)
    menhirSdk
    menhirLib
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    patchShebangs tests/merlin-wrapper
    dune runtest # filtering with -p disables tests
    runHook postCheck
  '';

  meta = with lib; {
    description = "An editor-independent tool to ease the development of programs in OCaml";
    homepage = "https://github.com/ocaml/merlin";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl maintainers.sternenseemann ];
  };
}
