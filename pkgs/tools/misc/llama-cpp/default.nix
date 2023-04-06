{ lib
, stdenv
, fetchFromGitHub
, cmake
, darwin
, makeWrapper
, python3
}:

stdenv.mkDerivation rec {
  pname = "llama-cpp";
  version = "unstable-2023-04-06";

  src = fetchFromGitHub {
    owner = "ggerganov";
    repo = "llama.cpp";
    rev = "master-cc9cee8";
    hash = "sha256-hJzkew4sXcVG4ALWdRwokAGruI+1JtI+Lx4bsVwJ/50=";
  };

  nativeBuildInputs = [ cmake makeWrapper ];

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ Accelerate CoreGraphics CoreVideo ]);

  pythonEnv = python3.withPackages (ps: with ps; [
    numpy
    torch
    numba
    tqdm
    sentencepiece
  ]);

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/libexec

    cp ./bin/main $out/bin/llama-cpp
    cp ./bin/perplexity $out/bin/llama-cpp-perplexity
    cp ./bin/embedding $out/bin/llama-cpp-embedding
    cp ./bin/quantize $out/bin/llama-cpp-quantize

    cp ../*.py $out/libexec/

    for f in $out/libexec/*.py; do
      makeWrapper ${pythonEnv}/bin/python "$out/bin/$(basename $f .py)" \
        --add-flags "$f"
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Port of Facebook's LLaMA model in C/C++";
    homepage = "https://github.com/ggerganov/llama.cpp/";
    license = licenses.mit;
    mainProgram = "llama-cpp";
    maintainers = with maintainers; [ dit7ya ];
  };
}
