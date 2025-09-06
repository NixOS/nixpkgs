{
  lib,
  metaFetch,
  coq,
  stdenv,
  version ? "0.2.1",
}:

let
  fetched = metaFetch ({
    release."0.2.1".sha256 = "sha256-HTT+/V7QtSJaBaiQlpCTIQWWb1eOEDMl5TmazqY9Ra8=";
    releaseRev = v: "rocqnavi.${v}";
    location = {
      domain = "github.com";
      owner = "affeldt-aist";
      repo = "rocqnavi";
    };
  }) version;
in
let
  inherit (fetched) version;
  inherit (coq) ocamlPackages;
  inherit (ocamlPackages) ocaml findlib;
in
stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-rocq-navi-${version}";
  inherit version;
  inherit (fetched) src;

  strictDepts = true;

  nativeBuildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin/
    make BINDIR=$out/bin install
    runHook postInstall
  '';

  meta = with lib; {
    description = "Extension of coq2html Document Generator";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.cohencyril ];
    homepage = "https://github.com/affeldt-aist/rocqnavi";
  };
}
