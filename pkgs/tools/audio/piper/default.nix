{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, espeak-ng
, onnxruntime
, pcaudiolib
, piper-train
}:

let
  pname = "piper";
  version = "0.0.2";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "piper";
    rev = "70afec58bc131010c8993c154ff02a78d1e7b8b0";
    hash = "sha256-zTW7RGcV8Hh7G6Braf27F/8s7nNjAqagp7tmrKO10BY=";
  };

  sourceRoot = "source/src/cpp";

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "/usr/local/include/onnxruntime" "${onnxruntime}"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    espeak-ng
    onnxruntime
    pcaudiolib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m 0755 piper $out/bin

    runHook postInstall
  '';

  passthru.tests = {
    inherit piper-train;
  };

  meta = with lib; {
    changelog = "https://github.com/rhasspy/piper/releases/tag/v${version}";
    description = "A fast, local neural text to speech system";
    homepage = "https://github.com/rhasspy/piper";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
