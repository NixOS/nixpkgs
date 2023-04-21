{ lib
, stdenv
, fetchFromGitHub
, libusb1
}:

stdenv.mkDerivation {
  pname = "chprog";
  version = "unstable-2021-08-20";

  src = fetchFromGitHub {
    owner = "ole00";
    repo = "chprog";
    rev = "2cf896831d98b25b401dc0ded8e52fd0b1a6c695";
    hash = "sha256-JZ0F9UXoWxHN3CSxPrUoYfKM+GEubthojgSRHXn3Gdw=";
  };

  postPatch = ''
    substituteInPlace build_linux.sh --replace gcc '$CC'
  '';

  buildInputs = [
    libusb1
  ];

  buildPhase = ''
    runHook preBuild
    sh ./build_linux.sh
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv chprog $out/bin/
    runHook postInstall
  '';

  meta = {
    description = "Tool to load firmware into ch55xx USB-to-Serial adapters";
    homepage = "https://github.com/ole00/chprog";
  };
}
