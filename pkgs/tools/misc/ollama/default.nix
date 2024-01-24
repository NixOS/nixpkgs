{ lib
, buildGoModule
, fetchFromGitHub
, llama-cpp
}:

let
  llama-cppNonStatic = (llama-cpp.override { static = false; });
in
buildGoModule rec {
  pname = "ollama";
  version = "0.1.21";

  src = fetchFromGitHub {
    owner = "jmorganca";
    repo = "ollama";
    rev = "v${version}";
    hash = "sha256-0hwzIJV3RiQrhAqoHzWYV2/bSXHae2JhbJ5wqEmc4VM=";
    fetchSubmodules = true;
  };

  preConfigure = ''
    export CGO_CFLAGS="-g"
  '';

  preBuild = ''
    go mod vendor
    go generate ./...
  '';

  postPatch = ''
    local arch="x86_64"
    local buildType="release"

    pushd llm

    mkdir -p llama.cpp/build/linux/$buildType/$arch

    cp -r ${llama-cppNonStatic}/lib llama.cpp/build/linux/$buildType/$arch

    popd
  '';

  buildPhase = ''
    go build .
  '';

  installPhase = ''
    mkdir -p $out/bin

    cp ollama $out/bin
  '';
  
  vendorHash = "sha256-wXRbfnkbeXPTOalm7SFLvHQ9j46S/yLNbFy+OWNSamQ=";

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
