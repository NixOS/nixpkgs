{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch

, cmake
}:

let
  pname = "ollama";
  version = "0.1.24";

  src = fetchFromGitHub {
    owner = "jmorganca";
    repo = "ollama";
    rev = "v${version}";
    hash = "sha256-GwZA1QUH8I8m2bGToIcMMaB5MBnioQP4+n1SauUJYP8=";
    fetchSubmodules = true;
  };
  preparePatch = patch: hash: fetchpatch {
    url = "file://${src}/llm/patches/${patch}";
    inherit hash;
    stripLen = 1;
    extraPrefix = "llm/llama.cpp/";
  };
  inherit (lib) licenses platforms maintainers;
  ollama = {
    inherit pname version src;
    vendorHash = "sha256-wXRbfnkbeXPTOalm7SFLvHQ9j46S/yLNbFy+OWNSamQ=";

    nativeBuildInputs = [ cmake ];

    patches = [
      # remove uses of `git` in the `go generate` script
      # instead use `patch` where necessary
      ./remove-git.patch
      # replace a hardcoded use of `g++` with `$CXX`
      ./replace-gcc.patch

      # ollama's patches of llama.cpp's example server
      # `ollama/llm/generate/gen_common.sh` -> "apply temporary patches until fix is upstream"
      (preparePatch "01-cache.diff" "sha256-PC4yN98hFvK+PEITiDihL8ki3bJuLVXrAm0CGf8GPJE=")
      (preparePatch "02-shutdown.diff" "sha256-cElAp9Z9exxN964vB/YFuBhZoEcoAwGSMCnbh+l/V4Q=")
    ];
    postPatch = ''
      # use a patch from the nix store in the `go generate` script
      substituteInPlace llm/generate/gen_common.sh \
        --subst-var-by cmakeIncludePatch '${./cmake-include.patch}'
      # `ollama/llm/generate/gen_common.sh` -> "avoid duplicate main symbols when we link into the cgo binary"
      substituteInPlace llm/llama.cpp/examples/server/server.cpp \
        --replace-fail 'int main(' 'int __main('
      # replace inaccurate version number with actual release version
      substituteInPlace version/version.go --replace-fail 0.0.0 '${version}'
    '';
    preBuild = ''
      export OLLAMA_SKIP_PATCHING=true
      # build llama.cpp libraries for ollama
      go generate ./...
    '';

    ldflags = [
      "-s"
      "-w"
      "-X=github.com/jmorganca/ollama/version.Version=${version}"
      "-X=github.com/jmorganca/ollama/server.mode=release"
    ];

    meta = {
      description = "Get up and running with large language models locally";
      homepage = "https://github.com/jmorganca/ollama";
      license = licenses.mit;
      platforms = platforms.unix;
      mainProgram = "ollama";
      maintainers = with maintainers; [ abysssol dit7ya elohmeier ];
    };
  };
in
buildGoModule ollama
