{ lib
, substituteAll
, fetchurl
, fetchpatch
, ocaml
, dune_3
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
  # Each releases of Merlin support a limited range of versions of OCaml.
  merlinVersions = {
    "4.12.0" = "4.7-412";
    "4.12.1" = "4.7-412";
    "4.13.0" = "4.7-413";
    "4.13.1" = "4.7-413";
    "4.14.0" = "4.16-414";
    "4.14.1" = "4.16-414";
    "4.14.2" = "4.16-414";
    "5.0.0" = "4.14-500";
    "5.1.0" = "4.16-501";
    "5.1.1" = "4.16-501";
    "5.2.0" = "5.1-502";
  };

  hashes = {
    "4.7-412" = "sha256-0U3Ia7EblKULNy8AuXFVKACZvGN0arYJv7BWiBRgT0Y=";
    "4.7-413" = "sha256-aVmGWS4bJBLuwsxDKsng/n0A6qlyJ/pnDTcYab/5gyU=";
    "4.14-500" = "sha256-7CPzJPh1UgzYiX8wPMbU5ZXz1wAJFNQQcp8WuGrR1w4=";
    "4.16-414" = "sha256-xekZdfPfVoSeGzBvNWwxcJorE519V2NLjSHkcyZvzy0=";
    "4.16-501" = "sha256-2lvzCbBAZFwpKuRXLMagpwDb0rz8mWrBPI5cODbCHiY=";
    "5.1-502" = "sha256-T9gIvCaSnP/MqOoGNEeQFZwQ4+r5yRTPRu956Rf8rhU=";
  };

  version = lib.getAttr ocaml.version merlinVersions;

in

if !lib.hasAttr ocaml.version merlinVersions
then builtins.throw "merlin is not available for OCaml ${ocaml.version}"
else

buildDunePackage {
  pname = "merlin";
  inherit version;

  src = fetchurl {
    url = "https://github.com/ocaml/merlin/releases/download/v${version}/merlin-${version}.tbz";
    sha256 = hashes."${version}";
  };

  patches = let
    branch = lib.head (lib.tail (lib.splitString "-" version));
    needsVimPatch = lib.versionOlder version "4.17" ||
                    branch == "502" && lib.versionOlder version "5.2";
  in
  [
    (substituteAll {
      src = ./fix-paths.patch;
      dot_merlin_reader = "${dot-merlin-reader}/bin/dot-merlin-reader";
      dune = "${dune_3}/bin/dune";
    })
  ] ++ lib.optionals needsVimPatch [
    # https://github.com/ocaml/merlin/pull/1798
    (fetchpatch {
      name = "vim-python-12-syntax-warning-fix.patch";
      url = "https://github.com/ocaml/merlin/commit/9e0c47b0d5fd0c4edc37c4c7ce927b155877557d.patch";
      hash = "sha256-HmdTISE/s45C5cwLgsCHNUW6OAPSsvQ/GcJE6VDEobs=";
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
    (if lib.versionAtLeast version "4.7-414"
     then merlin-lib
     else csexp)
    menhirSdk
    menhirLib
  ];

  doCheck = false;
  checkPhase = ''
    runHook preCheck
    patchShebangs tests/merlin-wrapper
    dune runtest # filtering with -p disables tests
    runHook postCheck
  '';

  meta = with lib; {
    description = "Editor-independent tool to ease the development of programs in OCaml";
    homepage = "https://github.com/ocaml/merlin";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl maintainers.sternenseemann ];
  };
}
