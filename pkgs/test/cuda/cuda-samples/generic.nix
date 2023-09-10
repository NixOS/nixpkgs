{ lib
, cudaPackages
, fetchFromGitHub
, fetchpatch
, addOpenGLRunpath
, cudatoolkit
, pkg-config
, sha256
, glfw3
, freeimage
}:
cudaPackages.backendStdenv.mkDerivation rec {
  pname = "cuda-samples";
  version = lib.versions.majorMinor cudatoolkit.version;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = pname;
    rev = "v${version}";
    inherit sha256;
  };

  nativeBuildInputs = [ pkg-config addOpenGLRunpath glfw3 freeimage ];

  buildInputs = [ cudatoolkit ];

  # See https://github.com/NVIDIA/cuda-samples/issues/75.
  patches = lib.optionals (version == "11.3") [
    (fetchpatch {
      url = "https://github.com/NVIDIA/cuda-samples/commit/5c3ec60faeb7a3c4ad9372c99114d7bb922fda8d.patch";
      sha256 = "sha256-0XxdmNK9MPpHwv8+qECJTvXGlFxc+fIbta4ynYprfpU=";
    })
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    export CUDA_PATH=${cudatoolkit}
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin bin/${cudaPackages.backendStdenv.hostPlatform.parsed.cpu.name}/${cudaPackages.backendStdenv.hostPlatform.parsed.kernel.name}/release/*

    runHook postInstall
  '';

  postFixup = ''
    for exe in $out/bin/*; do
      addOpenGLRunpath $exe
    done
  '';

  meta = {
    description = "Samples for CUDA Developers which demonstrates features in CUDA Toolkit";
    # CUDA itself is proprietary, but these sample apps are not.
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ obsidian-systems-maintenance ];
  };
}
