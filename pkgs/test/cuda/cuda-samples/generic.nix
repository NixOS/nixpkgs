{ autoAddOpenGLRunpathHook
, backendStdenv
, cmake
, cudatoolkit
, cudaVersion
, fetchFromGitHub
, fetchpatch
, freeimage
, glfw3
, lib
, pkg-config
, sha256
}:
backendStdenv.mkDerivation (finalAttrs: {
  pname = "cuda-samples";
  version = cudaVersion;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    inherit sha256;
  };

  nativeBuildInputs = [
    pkg-config
    autoAddOpenGLRunpathHook
    glfw3
    freeimage
  ]
  # CMake has to run as a native, build-time dependency for libNVVM samples.
  ++ lib.lists.optionals (lib.strings.versionAtLeast finalAttrs.version "12.2") [
    cmake
  ];

  # CMake is not the primary build tool -- that's still make.
  # As such, we disable CMake's build system.
  dontUseCmakeConfigure = true;

  buildInputs = [ cudatoolkit ];

  # See https://github.com/NVIDIA/cuda-samples/issues/75.
  patches = lib.optionals (finalAttrs.version == "11.3") [
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

    install -Dm755 -t $out/bin bin/${backendStdenv.hostPlatform.parsed.cpu.name}/${backendStdenv.hostPlatform.parsed.kernel.name}/release/*

    runHook postInstall
  '';

  meta = {
    description = "Samples for CUDA Developers which demonstrates features in CUDA Toolkit";
    # CUDA itself is proprietary, but these sample apps are not.
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ obsidian-systems-maintenance ] ++ lib.teams.cuda.members;
  };
})
