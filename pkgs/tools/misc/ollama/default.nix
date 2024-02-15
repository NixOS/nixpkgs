{ lib
, stdenv
, fetchpatch
, buildGoModule
, fetchFromGitHub
, llama-cpp
, darwin
}:

let
  version = "0.1.25";
  llama_lib = (llama-cpp.override {
      static = false;
    }).overrideDerivation (oldAttrs: {
      patches = [
        (fetchpatch {
          url = "https://github.com/ollama/ollama/raw/v${version}/llm/patches/01-cache.diff";
          hash = "sha256-MgaSEMaXyRhmD5SaYABe8zthfgVeWK6IyeK4lHmj8yE=";
        })
        (fetchpatch {
          url = "https://github.com/ollama/ollama/raw/v${version}/llm/patches/02-shutdown.diff";
          hash = "sha256-5VX8PaN+Yh9erdRARkpUXauuiDMPaCqTBdKjDRpzMRc=";
        })
      ];
    });
in
buildGoModule {
  pname = "ollama";
  version = version;

  src = fetchFromGitHub {
    owner = "jmorganca";
    repo = "ollama";
    rev = "v${version}";
    hash = "sha256-qrmG+wI3FgQegoW/vgUKOZIpcoVOvPB939+dtIfIIq0=";
  };

  buildInputs = [ llama_lib ]
    ++ llama_lib.buildInputs
    ++ lib.optionals stdenv.isDarwin
      (with darwin.apple_sdk.frameworks; [
        MetalPerformanceShaders
      ]);

  postPatch = let
    platformName = (lib.strings.toLower stdenv.targetPlatform.uname.system);
    platformArch = stdenv.targetPlatform.linuxArch;
  in ''
    mkdir -p llm/llama.cpp/build/${platformName}/${platformArch}/foo/
    [ -r "${llama_lib}/bin/ggml-metal.metal" ] && cp "${llama_lib}/bin/ggml-metal.metal" llm/llama.cpp/ggml-metal.metal
    cp -r "${lib.attrsets.getLib llama_lib}/lib" llm/llama.cpp/build/${platformName}/${platformArch}/foo/
    substituteInPlace version/version.go --replace-fail "0.0.0" "${version}"
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
