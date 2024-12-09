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
    if lib.versionAtLeast ocaml.version "5.2" then
      {
        version = "4.0.1-52";
        hash = "sha256-kUlChqQtLX7zh90GK23ibMqyI/MIp0sMYLjkPX9vdTc=";
      }
    else if lib.versionAtLeast ocaml.version "5.1" then
      {
        version = "4.0.0-51";
        hash = "sha256-940Yzp1ZXnN6mKVWY+nqKjn4qtBUJR5eHE55OTjGvdU=";
      }
    else
      {
        version = "4.0.0-414";
        hash = "sha256-PILDOXYIyLvfv1sSwP6WSdCiXfpYdnct7WMw3jHBLJM=";
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
  doCheck = true;
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
