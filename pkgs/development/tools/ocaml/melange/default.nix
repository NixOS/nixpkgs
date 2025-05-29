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
    if lib.versionAtLeast ocaml.version "5.3" then
      {
        version = "5.0.0-53";
        hash = "sha256-ZZ3/TdhEJQ74Q3wJkWqoiONEfV6x77z0Sbr8cAirXbA=";
      }
    else if lib.versionAtLeast ocaml.version "5.2" then
      {
        version = "5.0.0-52";
        hash = "sha256-DyjBiMvnCHufFepk8xHMMmVU+j/yECvV7My4WeAW4WQ=";
      }
    else if lib.versionAtLeast ocaml.version "5.1" then
      {
        version = "5.0.0-51";
        hash = "sha256-rPU6pqzEDo5heGkHhMGfwsF8elDohoptNbbZyGcWLKA=";
      }
    else if lib.versionAtLeast ocaml.version "5.0" then
      throw "melange is not available for OCaml ${ocaml.version}"
    else
      {
        version = "5.0.0-414";
        hash = "sha256-07+tEx6b5dUY949VF2K22HqRSoKmvBwnxo7B/Gqb+ro=";
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
  propagatedBuildInputs = [
    cmdliner
    dune-build-info
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
