{
  lib,
  replaceVars,
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
  # Each releases of Merlin support a limited range of versions of OCaml.
  version ?
    {
      "4.12.0" = "4.7-412";
      "4.12.1" = "4.7-412";
      "4.13.0" = "4.7-413";
      "4.13.1" = "4.7-413";
      "4.14.0" = "4.19-414";
      "4.14.1" = "4.19-414";
      "4.14.2" = "4.19-414";
      "5.0.0" = "4.14-500";
      "5.1.0" = "4.17.1-501";
      "5.1.1" = "4.17.1-501";
      "5.2.0" = "5.3-502";
      "5.2.1" = "5.3-502";
      "5.3.0" = "5.6-503";
      "5.4.0" = "5.6-504";
    }
    ."${ocaml.version}",
}:

let

  hashes = {
    "4.7-412" = "sha256-0U3Ia7EblKULNy8AuXFVKACZvGN0arYJv7BWiBRgT0Y=";
    "4.7-413" = "sha256-aVmGWS4bJBLuwsxDKsng/n0A6qlyJ/pnDTcYab/5gyU=";
    "4.14-500" = "sha256-7CPzJPh1UgzYiX8wPMbU5ZXz1wAJFNQQcp8WuGrR1w4=";
    "4.16-414" = "sha256-xekZdfPfVoSeGzBvNWwxcJorE519V2NLjSHkcyZvzy0="; # Used by ocaml-lsp
    "4.16-501" = "sha256-2lvzCbBAZFwpKuRXLMagpwDb0rz8mWrBPI5cODbCHiY="; # Used by ocaml-lsp
    "4.18-414" = "sha256-9tb3omYUHjWMGoaWEsgTXIWRhdVH6julya17tn/jDME=";
    "4.19-414" = "sha256-YKYw9ZIDqc5wR6XwTQ8jmUWWDaxvOBApIuMottJlc4Q=";
    "4.17.1-501" = "sha256-N2cHqocfCeljlFbT++S4miHJrXXHdOlMu75n+EKwpQA=";
    "5.3-502" = "sha256-LOpG8SOX+m4x7wwNT14Rwc/ZFu5JQgaUAFyV67OqJLw=";
    "5.4.1-503" = "sha256-SbO0x3jBISX8dAXnN5CwsxLV15dJ3XPUg4tlYqJTMCI=";
    "5.6-503" = "sha256-sNytCSqq96I/ZauaCJ6HYb1mXMcjV5CeCsbCGC9PwtQ=";
    "5.6-504" = "sha256-gtZIpBgNbVqjoIMhjii/GX9OnxR4hN6TArtoEa2Yt38=";
  };

in

buildDunePackage {
  pname = "merlin";
  inherit version;

  src = fetchurl {
    url = "https://github.com/ocaml/merlin/releases/download/v${version}/merlin-${version}.tbz";
    sha256 = hashes."${version}";
  };

  patches =
    let
      old-patch = lib.versionOlder version "4.17";
    in
    [
      (replaceVars (if old-patch then ./fix-paths.patch else ./fix-paths2.patch) {
        dot-merlin-reader = "${dot-merlin-reader}/bin/dot-merlin-reader";
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
    description = "Editor-independent tool to ease the development of programs in OCaml";
    homepage = "https://github.com/ocaml/merlin";
    license = licenses.mit;
    mainProgram = "ocamlmerlin";
    maintainers = [
      maintainers.vbgl
      maintainers.sternenseemann
    ];
  };
}
