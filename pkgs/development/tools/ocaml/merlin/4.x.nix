{ lib
, substituteAll
, fetchurl
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
  merlinVersion = if lib.versionAtLeast ocaml.version "4.14" then "4.12" else "4.7";

  hashes = {
    "4.7-412" = "sha256-0U3Ia7EblKULNy8AuXFVKACZvGN0arYJv7BWiBRgT0Y=";
    "4.7-413" = "sha256-aVmGWS4bJBLuwsxDKsng/n0A6qlyJ/pnDTcYab/5gyU=";
    "4.8-414" = "sha256-HMXWhcVOXW058y143rNBcfEOmjt2tZJXcXKHmKZ5i68=";
    "4.8-500" = "sha256-n5NHKuo0/lZmfe7WskqnW3xm1S0PmXKSS93BDKrpjCI=";
    "4.9-414" = "sha256-4j/EeBNZEmn/nSfIIJiOUgpmLIndCvfqZSshUXSZy/0=";
    "4.9-500" = "sha256-uQfGazoxTxclHSiTfjji+tKJv8MKqRdHMPD/xfMZlSY=";
    "4.10-414" = "sha256-/a1OqASISpb06eh2gsam1rE3wovM4CT8ybPV86XwR2c=";
    "4.10-500" = "sha256-m9+Qz8DT94yNSwpamTVLQKISHtRVBWnZD3t/yyujSZ0=";
    "4.12-414" = "sha256-tgMUT4KyFeJubYVY1Sdv9ZvPB1JwcqEGcCuwuMqXHRQ=";
    "4.12-500" = "sha256-j49R7KVzNKlXDL7WibTHxPG4VSOVv0uaz5/yMZZjkH8=";
    "4.12-501" = "sha256-zMwzI1SXQDWQ9PaKL4o3J6JlRjmEs7lkXrwauy+QiMA=";
  };

  ocamlVersionShorthand =
    let
      v = lib.splitVersion ocaml.version;
      major = builtins.elemAt v 0;
      minor = builtins.elemAt v 1;
      minor_prefix = if builtins.stringLength minor < 2 then "0" else "";
    in "${toString major}${minor_prefix}${toString minor}";

  version = "${merlinVersion}-${ocamlVersionShorthand}";
in

if !lib.hasAttr version hashes
then builtins.throw "merlin ${merlinVersion} is not available for OCaml ${ocaml.version}"
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
    description = "An editor-independent tool to ease the development of programs in OCaml";
    homepage = "https://github.com/ocaml/merlin";
    license = licenses.mit;
    maintainers = [ maintainers.vbgl maintainers.sternenseemann ];
  };
}
