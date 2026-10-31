/*
    Test CUDA packages.

    This release file is currently not tested on hydra.nixos.org
    because it requires unfree software.

    Test for example like this:

        $ hydra-eval-jobs pkgs/top-level/release-cuda.nix -I .
*/

let
  lib = import ../../lib;
  _cuda = import ../development/cuda-modules/_cuda;
  cudaLib = _cuda.lib;

  isBaselineJetsonCapability =
    cudaCapabilityInfo:
    cudaCapabilityInfo.isJetson
    && !cudaCapabilityInfo.isArchitectureSpecific
    && !cudaCapabilityInfo.isFamilySpecific;
in

{
  # The platforms for which we build Nixpkgs.
  supportedSystems ? [
    "x86_64-linux"
    "aarch64-linux"
  ],
  variant ? "cuda",
  # CUDA capabilities to build one at a time.
  # The default is Jetson, because Jetson cannot be built with other capabilities.
  extraCudaCapabilities ? lib.attrNames (
    lib.filterAttrs (_: isBaselineJetsonCapability) _cuda.db.cudaCapabilityToInfo
  ),
  # Attributes passed to nixpkgs.
  nixpkgsArgs ? {
    config = {
      allowUnfreePredicate = cudaLib.allowUnfreeCudaPredicate;
      # [CVE-2026-24188](https://github.com/NixOS/nixpkgs/issues/522570):
      # OOB write
      allowInsecurePredicate = p: lib.getName p == "tensorrt";
      "${variant}Support" = true;
      inHydra = true;

      # Don't evaluate duplicate and/or deprecated attributes
      allowAliases = false;
    };

    __allowFileset = false;
  },
  ...
}@args:

assert builtins.elem variant [
  "cuda"
  "rocm"
  null
];

let
  mkReleaseLib = import ./release-lib.nix;
  release-lib = mkReleaseLib (
    { inherit supportedSystems nixpkgsArgs; } // lib.intersectAttrs (lib.functionArgs mkReleaseLib) args
  );

  inherit (release-lib)
    linux
    mapTestOn
    packagePlatforms
    pkgs
    pkgsFor
    supportedMatches
    ;

  # backendStdenv asserts that it can target the configured capabilities.
  canTargetConfiguredCapabilities =
    cudaPackages: (builtins.tryEval cudaPackages.backendStdenv).success;

  # Package sets to evaluate whole
  # Derivations from these package sets are selected based on the value
  # of their meta.{hydraPlatforms,platforms,badPlatforms} attributes
  autoPackagePlatformsIn =
    targetPkgs:
    let
      isCudaPackageSet = lib.strings.hasPrefix "cudaPackages";
      autoPackageSets = builtins.filter (
        pset: isCudaPackageSet pset && canTargetConfiguredCapabilities targetPkgs.${pset}
      ) (builtins.attrNames targetPkgs);
    in
    lib.genAttrs autoPackageSets (pset: packagePlatforms targetPkgs.${pset});

  # Explicitly select additional packages to also evaluate
  # The desired platforms must be set explicitly here
  explicitPackagePlatforms =
    # This comment prevents nixfmt from changing the indentation level, lol
    {
      blas = linux;
      blender = linux;
      faiss = linux;
      lapack = linux;
      magma = linux;
      mpich = linux;
      openmpi = linux;
      ucx = linux;

      opencv = linux;
      cctag = linux; # Failed in https://github.com/NixOS/nixpkgs/pull/233581

      cholmod-extra = linux;
      colmap = linux;
      ctranslate2 = linux;
      ffmpeg-full = linux;
      firefox = linux;
      firefox-unwrapped = linux;
      firefox-beta = linux;
      firefox-beta-unwrapped = linux;
      firefox-devedition = linux;
      firefox-devedition-unwrapped = linux;
      freecad = linux;
      gimp = linux;
      gpu-screen-recorder = linux;
      gst_all_1.gst-plugins-bad = linux;
      jellyfin-ffmpeg = linux;
      kdePackages.kdenlive = linux;
      krita = linux;
      lightgbm = linux;
      llama-cpp = linux;
      meshlab = linux;
      mistral-rs = linux;
      monado = linux; # Failed in https://github.com/NixOS/nixpkgs/pull/233581
      noisetorch = linux;
      obs-studio-plugins.obs-backgroundremoval = linux;
      octave = linux; # because depend on SuiteSparse which need rebuild when cuda enabled
      ollama = linux;
      onnxruntime = linux;
      openmvg = linux;
      openmvs = linux;
      opentrack = linux;
      openvino = linux;
      pixinsight = linux; # Failed in https://github.com/NixOS/nixpkgs/pull/233581
      qgis = linux;
      rtabmap = linux;
      saga = linux;
      suitesparse = linux;
      sunshine = linux;
      thunderbird = linux;
      thunderbird-unwrapped = linux;
      truecrack-cuda = linux;
      tts = linux;
      ueberzugpp = linux; # Failed in https://github.com/NixOS/nixpkgs/pull/233581
      wyoming-faster-whisper = linux;
      xgboost = linux;

      python3Packages = {
        catboost = linux;
        cupy = linux;
        faiss = linux;
        faster-whisper = linux;
        flashinfer-python = linux;
        flax = linux;
        gpt-2-simple = linux;
        grad-cam = linux;
        jaxlib = linux;
        jax = linux;
        keras = linux;
        kornia = linux;
        mmcv = linux;
        mxnet = linux;
        numpy = linux; # Only affected by MKL?
        onnx = linux;
        triton = linux;
        openai-whisper = linux;
        opencv4 = linux;
        opencv4Full = linux;
        opensfm = linux;
        pycuda = linux;
        pymc = linux;
        pyrealsense2WithCuda = linux;
        pytorch-lightning = linux;
        scikit-image = linux;
        scikit-learn = linux; # Only affected by MKL?
        scipy = linux; # Only affected by MKL?
        spacy-transformers = linux;
        tensorflow = linux;
        tensorflow-probability = linux;
        tesserocr = linux;
        tiny-cuda-nn = linux;
        torchaudio = linux;
        torch = linux;
        torchvision = linux;
        transformers = linux;
        ttstokenizer = linux;
        vidstab = linux;
        vllm = linux;
      };
    };

  allPackagePlatformsIn =
    targetPkgs: lib.recursiveUpdate (autoPackagePlatformsIn targetPkgs) explicitPackagePlatforms;

  mergePackagePlatforms = lib.zipAttrsWith (
    _: values:
    if lib.all lib.isList values then
      lib.unique (lib.concatLists values)
    else
      mergePackagePlatforms values
  );

  packagePlatformsFor =
    cudaCapability:
    let
      pkgsForCapabilityOn =
        system: (pkgsFor system).pkgsForCudaArch.${cudaLib.mkRealArchitecture cudaCapability};
      canTargetCapabilityOn =
        system: canTargetConfiguredCapabilities (pkgsForCapabilityOn system).cudaPackages;
      packagePlatformsOn =
        system:
        lib.mapAttrsRecursive (
          _: declaredPlatforms: lib.intersectLists (supportedMatches declaredPlatforms) [ system ]
        ) (allPackagePlatformsIn (pkgsForCapabilityOn system));
    in
    mergePackagePlatforms (map packagePlatformsOn (lib.filter canTargetCapabilityOn supportedSystems));

  extraCudaCapabilityPackagePlatforms =
    let
      hasPackages = _: packagePlatforms: packagePlatforms != { };
      packagePlatformsByArchitecture = lib.genAttrs' extraCudaCapabilities (
        cudaCapability:
        lib.nameValuePair (cudaLib.mkRealArchitecture cudaCapability) (packagePlatformsFor cudaCapability)
      );
    in
    lib.filterAttrs hasPackages packagePlatformsByArchitecture;

  jobs = mapTestOn (
    allPackagePlatformsIn pkgs
    // lib.optionalAttrs (variant == "cuda") {
      pkgsForCudaArch = extraCudaCapabilityPackagePlatforms;
    }
  );
in
jobs
