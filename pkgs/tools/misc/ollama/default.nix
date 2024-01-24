{ lib
, buildGoModule
, fetchFromGitHub
, config
, llama-cpp
, makeWrapper
, cudaSupport ? config.cudaSupport
  # TODO: missing ROCm support
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
  };


  preBuild = ''
    go mod vendor
    go generate ./...
  '';

  # TODO: missing darwin support
  postPatch = ''
    local arch="foo"
    local buildType="release"

    pushd llm

    mkdir -p llama.cpp/build/linux/$buildType/$arch

    cp -r ${llama-cppNonStatic}/lib llama.cpp/build/linux/$buildType/$arch
    
    popd

    substituteInPlace version/version.go --replace "0.0.0" "${version}"
  '';

  buildPhase = ''
    go build .
  '';

  installPhase = ''
    mkdir -p $out/bin

    cp ollama $out/bin

  '' + lib.optionalString cudaSupport ''
    wrapProgram $out/bin/ollama --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib"
  '';

  vendorHash = "sha256-wXRbfnkbeXPTOalm7SFLvHQ9j46S/yLNbFy+OWNSamQ=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/jmorganca/ollama/version.Version=${version}"
    "-X=github.com/jmorganca/ollama/server.mode=release"
  ];

  nativeBuildInputs = lib.optionals cudaSupport [
    makeWrapper
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
