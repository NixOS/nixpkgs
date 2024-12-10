{
  lib,
  substituteAll,
  fetchurl,
  ocaml,
  dune_3,
  buildDunePackage,
  yojson,
  csexp,
  merlin-lib,
  dot-merlin-reader,
  jq,
  menhir,
  menhirLib,
  menhirSdk,
}:

let
  # Each releases of Merlin support a limited range of versions of OCaml.
  merlinVersions = {
    "4.12.0" = "4.7-412";
    "4.12.1" = "4.7-412";
    "4.13.0" = "4.7-413";
    "4.13.1" = "4.7-413";
    "4.14.0" = "4.14-414";
    "4.14.1" = "4.14-414";
    "4.14.2" = "4.14-414";
    "5.0.0" = "4.14-500";
    "5.1.0" = "4.14-501";
    "5.1.1" = "4.14-501";
  };

  hashes = {
    "4.7-412" = "sha256-0U3Ia7EblKULNy8AuXFVKACZvGN0arYJv7BWiBRgT0Y=";
    "4.7-413" = "sha256-aVmGWS4bJBLuwsxDKsng/n0A6qlyJ/pnDTcYab/5gyU=";
    "4.14-414" = "sha256-eQGMyqN8FQHdXE1c94vDQg1kGx6CRDZimBxUctlzmT0=";
    "4.14-500" = "sha256-7CPzJPh1UgzYiX8wPMbU5ZXz1wAJFNQQcp8WuGrR1w4=";
    "4.14-501" = "sha256-t+npbpJAWMLOQpZCeIqi45ByDUQeIkU4vPSUplIDopI=";
  };

  version = lib.getAttr ocaml.version merlinVersions;
in

if !lib.hasAttr ocaml.version merlinVersions then
  builtins.throw "merlin is not available for OCaml ${ocaml.version}"
else

  buildDunePackage {
    pname = "merlin";
    inherit version;
    duneVersion = "3";

    src = fetchurl {
      url = "https://github.com/ocaml/merlin/releases/download/v${version}/merlin-${version}.tbz";
      sha256 = hashes."${version}";
    };

    patches = [
      (substituteAll {
        src = ./fix-paths.patch;
        dot_merlin_reader = "${dot-merlin-reader}/bin/dot-merlin-reader";
        dune = "${dune_3}/bin/dune";
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
      (if lib.versionAtLeast version "4.7-414" then merlin-lib else csexp)
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
      description = "An editor-independent tool to ease the development of programs in OCaml";
      homepage = "https://github.com/ocaml/merlin";
      license = licenses.mit;
      maintainers = [
        maintainers.vbgl
        maintainers.sternenseemann
      ];
    };
  }
