{
  buildDunePackage,
  cmdliner,
  cppo,
  dune-build-info,
  fetchurl,
  jq,
  lib,
  makeWrapper,
  menhirLib,
  merlin,
  nodejs,
  ocaml,
  ounit2,
  ppxlib,
  reason,
  stdenv,
  tree,
}:

let
  pname = "melange";
  versionHash =
    if lib.versionAtLeast ocaml.version "5.4" then
      {
        version = "6.0.0-54";
        hash = "sha256-689OK37ObYhopfcaJ3AmkScGC4lCu3ZOTEM6N+Npvzs=";
      }
    else if lib.versionAtLeast ocaml.version "5.3" then
      {
        version = "6.0.0-53";
        hash = "sha256-jPTQvV095BPB4EDepwGJTZ9sB/60VTO4YJTj2wI39jc=";
      }
    else if lib.versionAtLeast ocaml.version "5.2" then
      {
        version = "5.1.0-52";
        hash = "sha256-EGIInGCo3JADYyE4mLw5Fzkm4OB+V9yi2ayV0lVq3v0=";
      }
    else if lib.versionAtLeast ocaml.version "5.1" then
      {
        version = "5.1.0-51";
        hash = "sha256-DIF8vZLEKsFf6m5tl1/T6zqjHyKxDMois2h//tDhsJI=";
      }
    else if lib.versionAtLeast ocaml.version "5.0" then
      throw "melange is not available for OCaml ${ocaml.version}"
    else
      {
        version = "5.1.0-414";
        hash = "sha256-Sv1XyOqCNhICTsXzetXh/zqX/tdTupYZ0Q1nZRLfpe0=";
      };
  version = versionHash.version;
  hash = versionHash.hash;
in
buildDunePackage {
  inherit pname;
  inherit version;
  minimalOCamlVersion = "4.14";
  src = fetchurl {
    url = "https://github.com/melange-re/${pname}/releases/download/${version}/${pname}-${version}.tbz";
    inherit hash;
  };
  nativeBuildInputs = [
    cppo
    makeWrapper
  ];
  buildInputs = [
    cmdliner
    dune-build-info
  ];
  propagatedBuildInputs = [
    menhirLib
    ppxlib
  ];
  doCheck = false;
  nativeCheckInputs = [
    jq
    merlin
    nodejs
    reason
    tree
  ];
  checkInputs = [
    ounit2
  ];
  postInstall = ''
    wrapProgram "$out/bin/melc" --set MELANGELIB "$OCAMLFIND_DESTDIR/melange/melange:$OCAMLFIND_DESTDIR/melange/js/melange"
  '';
  meta = {
    description = "Toolchain to produce JS from Reason/OCaml";
    homepage = "https://melange.re/";
    mainProgram = "melc";
    license = lib.licenses.lgpl3;
    maintainers = [
      lib.maintainers.vog
    ];
  };
}
