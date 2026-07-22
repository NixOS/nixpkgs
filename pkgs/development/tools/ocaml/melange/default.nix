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
        version = "7.0.0-55";
        hash = "sha256:f71d2910599c230506efe01f43e02d16d4468fdaea34b537e9e3dfd7383cdf56";
      }
    else if lib.versionAtLeast ocaml.version "5.4" then
      {
        version = "7.0.0-54";
        hash = "sha256:cb78172b329c1a0a1c120801d2b915c03c83d2027014ba88416e7cafc1251a7c";
      }
    else if lib.versionAtLeast ocaml.version "5.3" then
      {
        version = "7.0.0-53";
        hash = "sha256:2b3d94a770d1ce7d9cf43a83c1e61e176b0a13b7472c166bb6856121b5bd6e64";
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
