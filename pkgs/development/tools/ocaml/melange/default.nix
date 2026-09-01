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
    if lib.versionAtLeast ocaml.version "5.5" then
      {
        version = "7.0.1-55";
        hash = "sha256:8377c0860da82528ebde16a0133f270c1a03de35036bd44bbd8cfb87070a7afb";
      }
    else if lib.versionAtLeast ocaml.version "5.4" then
      {
        version = "7.0.1-54";
        hash = "sha256:49bf9d3dd10d0d7f58abe6755a40c246d36b5fbf6b5e189f2c634c47a9de7f33";
      }
    else if lib.versionAtLeast ocaml.version "5.3" then
      {
        version = "7.0.1-53";
        hash = "sha256:25177453269467832be7b6416f1104132265a3309b9098e6b5185b9c0df05150";
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
