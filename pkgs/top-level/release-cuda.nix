/*
    Test CUDA packages.

    This release file is currently not tested on hydra.nixos.org
    because it requires unfree software, but it is tested by
    https://hydra.nix-community.org/jobset/nixpkgs/cuda-nixos-unstable.

    Cf. https://github.com/nix-community/infra/pull/1335

    Test for example like this:

        $ hydra-eval-jobs pkgs/top-level/release-cuda.nix -I .
*/

let
  ensureList = x: if builtins.isList x then x else [ x ];
  allowUnfreePredicate =
    p:
    builtins.all (
      license:
      license.free
      || builtins.elem license.shortName [
        "CUDA EULA"
        "cuDNN EULA"
        "cuTENSOR EULA"
        "NVidia OptiX EULA"
      ]
    ) (ensureList p.meta.license);
in

{
  # The platforms for which we build Nixpkgs.
  supportedSystems ? [
    "x86_64-linux"
    "aarch64-linux"
  ],
  variant ? "cuda",
  # Attributes passed to nixpkgs.
  nixpkgsArgs ? {
    config = {
      inherit allowUnfreePredicate;
      "${variant}Support" = true;
      inHydra = true;
    };
  },
  ...
}@args:

assert builtins.elem variant [
  "cuda"
  "rocm"
  null
];

let
  release-lib = import ./release-lib.nix (
    { inherit supportedSystems nixpkgsArgs; } // builtins.removeAttrs args [ "variant" ]
  );

  inherit (release-lib) lib;
  inherit (release-lib)
    linux
    mapTestOn
    packagePlatforms
    pkgs
    ;

  # Package sets to evaluate whole
  packageSets = builtins.filter (lib.strings.hasPrefix "cudaPackages") (builtins.attrNames pkgs);
  evalPackageSet = pset: mapTestOn { ${pset} = packagePlatforms pkgs.${pset}; };

  jobs =
    mapTestOn {
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
      deepin.image-editor = linux;
      ffmpeg-full = linux;
      gimp = linux;
      gpu-screen-recorder = linux;
      gst_all_1.gst-plugins-bad = linux;
      lightgbm = linux;
      llama-cpp = linux;
      meshlab = linux;
      monado = linux; # Failed in https://github.com/NixOS/nixpkgs/pull/233581
      noisetorch = linux;
      obs-studio-plugins.obs-backgroundremoval = linux;
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
      truecrack-cuda = linux;
      tts = linux;
      ueberzugpp = linux; # Failed in https://github.com/NixOS/nixpkgs/pull/233581
      wyoming-faster-whisper = linux;
      xgboost = linux;

      python3Packages = {
        boxx = linux;
        bpycv = linux;
        caffe = linux;
        catboost = linux;
        chainer = linux;
        cupy = linux;
        faiss = linux;
        faster-whisper = linux;
        flax = linux;
        gpt-2-simple = linux;
        grad-cam = linux;
        jaxlib = linux;
        jax = linux;
        Keras = linux;
        kornia = linux;
        mmcv = linux;
        mxnet = linux;
        numpy = linux; # Only affected by MKL?
        onnx = linux;
        triton = linux;
        openai-whisper = linux;
        opencv4 = linux;
        opensfm = linux;
        pycuda = linux;
        pymc = linux;
        pyrealsense2WithCuda = linux;
        pytorch-lightning = linux;
        pytorch = linux;
        scikitimage = linux;
        scikit-learn = linux; # Only affected by MKL?
        scipy = linux; # Only affected by MKL?
        spacy-transformers = linux;
        tensorflow = linux;
        tensorflow-probability = linux;
        tesserocr = linux;
        Theano = linux;
        tiny-cuda-nn = linux;
        torchaudio = linux;
        torch = linux;
        torchvision = linux;
        transformers = linux;
        ttstokenizer = linux;
        vidstab = linux;
      };
    }
    // (lib.genAttrs packageSets evalPackageSet);
in
jobs
