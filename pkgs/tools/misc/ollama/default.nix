{ lib
, buildGoModule
, fetchFromGitHub
, llama-cpp
, stdenv
}:

buildGoModule rec {
  pname = "ollama";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "jmorganca";
    repo = "ollama";
    rev = "v${version}";
    hash = "sha256-rzcuRU2qcYTMo/GxiSHwJYnvA9samfWlztMEhOGzbRg=";
  };

  patches = [
    # disable passing the deprecated gqa flag to llama-cpp-server
    # see https://github.com/ggerganov/llama.cpp/issues/2975
    ./disable-gqa.patch

    # replace the call to the bundled llama-cpp-server with the one in the llama-cpp package
    ./set-llamacpp-path.patch
  ];

  postPatch = ''
    substituteInPlace llm/llama.go \
      --subst-var-by llamaCppServer "${llama-cpp}/bin/llama-cpp-server"
  '';

  vendorHash = "sha256-Qt5QVqRkwK61BJPVhFWtox6b9E8BpAIseNB0yhh+/90=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/jmorganca/ollama/version.Version=${version}"
    "-X=github.com/jmorganca/ollama/server.mode=release"
  ];

  meta = with lib; {
    description = "Get up and running with large language models locally";
    homepage = "https://github.com/jmorganca/ollama";
    license = licenses.mit;
    mainProgram = "ollama";
    maintainers = with maintainers; [ dit7ya elohmeier ];
    platforms = platforms.unix;
  };
}
