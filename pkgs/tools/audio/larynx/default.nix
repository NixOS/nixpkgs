{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, espeak-ng
, onnxruntime
, pcaudiolib
, larynx-train
}:

let
  pname = "larynx";
  version = "0.0.2";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "larynx2";
    rev = "refs/tags/v${version}";
    hash = "sha256-6SZ1T2A1DyVmBH2pJBHJdsnniRuLrI/dthRTRRyVSQQ=";
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
    install -m 0755 larynx $out/bin

    runHook postInstall
  '';

  passthru.tests = {
    inherit larynx-train;
  };

  meta = with lib; {
    changelog = "https://github.com/rhasspy/larynx2/releases/tag/v${version}";
    description = "A fast, local neural text to speech system";
    homepage = "https://github.com/rhasspy/larynx2";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
