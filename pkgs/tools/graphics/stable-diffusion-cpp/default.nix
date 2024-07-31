{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
, makeWrapper
, darwin
}:

let
  pythonEnv = python3.withPackages (ps: with ps; [ numpy torch safetensors pytorch-lightning ]);
in

stdenv.mkDerivation {
  pname = "stable-diffusion-cpp";
  version = "unstable-2023-08-20";

  src = fetchFromGitHub {
    owner = "leejet";
    repo = "stable-diffusion.cpp";
    rev = "17095dddea68ec228f0ef5d113a41b5f5dd599dc";
    hash = "sha256-kHQ6qG9tG02AiT4szji5Klkuwf4hjeYdzDoZLMy/I6g=";
    fetchSubmodules = true;
  };

  buildInputs = lib.optionals stdenv.isDarwin [darwin.apple_sdk_11_0.frameworks.Accelerate];

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  postFixup = ''
    mkdir -p $out/libexec
    cp ../models/convert.py ../models/vocab.json $out/libexec

    makeWrapper ${pythonEnv}/bin/python $out/bin/sd-convert-to-ggml --add-flags $out/libexec/convert.py
  '';

  meta = {
    description = "Stable Diffusion in pure C/C++";
    longDescription = ''
      Stable Diffusion in pure C/C++.

      To convert the model to GGML format, as described in the project's README,
      use the `sd-convert-to-ggml` binary.
    '';
    homepage = "https://github.com/leejet/stable-diffusion.cpp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "sd";
  };
}
