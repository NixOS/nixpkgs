{
  buildDunePackage,
  cmdliner,
  cppo,
  dune-build-info,
  fetchurl,
  fetchpatch,
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
    if lib.versionAtLeast ocaml.version "5.3" then
      {
        version = "5.1.0-53";
        hash = "sha256-96rDDzul/v+Dc+IWTNtbOKWUV8rf7HS1ZMK2LQNcpKk=";
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
  patches = lib.optional (lib.versionAtLeast ppxlib.version "0.36") (fetchpatch {
    url = "https://patch-diff.githubusercontent.com/raw/melange-re/melange/pull/1352.patch";
    hash = "sha256-PMf66nB743nzW4/xblHjNZFv1BS8xC9maD+eCDDUWAY=";
    excludes = [
      "*.opam"
      "*.template"
    ];
  });
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
