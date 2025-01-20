{ lib
, config
, stdenv
, buildPythonPackage
, fetchFromGitHub
, buildBazelPackage
, bazel_5
, python
, absl-py
, setuptools
, wheel
, numpy
, binutils
, cudaPackages
, symlinkJoin
, cudaSupport ? config.cudaSupport or false
}:

let
  pname = "tensorflow-io";
  version = "0.30.0";

  inherit (cudaPackages) cudatoolkit cudnn nccl cudaFlags;

  cudatoolkit_joined = symlinkJoin {
    name = "${cudatoolkit.name}-merged";
    paths = [
      cudatoolkit.lib
      cudatoolkit.out
    ] ++ lib.optionals (lib.versionOlder cudatoolkit.version "11") [
      # for some reason some of the required libs are in the targets/x86_64-linux
      # directory; not sure why but this works around it
      "${cudatoolkit}/targets/${stdenv.system}"
    ];
  };

  cudatoolkit_cc_joined = symlinkJoin {
    name = "${cudatoolkit.cc.name}-merged";
    paths = [
      cudatoolkit.cc
      binutils.bintools # for ar, dwp, nm, objcopy, objdump, strip
    ];
  };

  bazel-wheel = buildBazelPackage {
    name = "${pname}-${version}-py2.py3-none-any.whl";
    src = fetchFromGitHub {
      owner = "tensorflow";
      repo = "io";
      rev = "v${version}";
      hash = "sha256-SeXw9MES7tyMQ34jR9NHtO3S+y6nsvU6z0JCjj0r6Mk=";
    };
    patches = [
      ./remove-lint_dependencies.patch
    ];
    postPatch =
      let
        # Cf. https://github.com/bazelbuild/rules_python/blob/82c8f0a084c35dafc381725c195597910cbab218/.github/workflows/workspace_snippet.sh#L9
        rulesPython.tags = {
          "0.1.0" = "48f7e716f4098b85296ad93f5a133baf712968c13fbc2fdf3a6136158fe86eac";
          "0.2.0" = "0d25ab1c7b18b3f48d1bff97bfa70c1625438b40c5f661946fb43eca4ba9d9dd";
          "0.3.0" = "4feecd37ec6e9941a455a19e7392bed65003eab0aa6ea347ca431bce2640e530";
          "0.4.0" = "45f22030b4c3475d5beb74ee9a9b86df6e83d5e18c6f23c7ec1a43cea7a31b93";
          "0.5.0" = "a2fd4c2a8bcf897b718e5643040b03d9528ac6179f6990774b7c19b2dc6cd96b";
          "0.6.0" = "a30abdfc7126d497a7698c29c46ea9901c6392d6ed315171a6df5ce433aa4502";
          "0.7.0" = "15f84594af9da06750ceb878abbf129241421e3abbd6e36893041188db67f2fb";
          "0.8.0" = "9fcf91dbcc31fde6d1edb15f117246d912c33c36f44cf681976bd886538deba6";
          "0.9.0" = "5fa3c738d33acca3b97622a13a741129f67ef43f5fdfcec63b29374cc0574c29";
          "0.10.0" = "56dc7569e5dd149e576941bdb67a57e19cd2a7a63cc352b62ac047732008d7e1";
          "0.11.0" = "c03246c11efd49266e8e41e12931090b613e12a59e6f55ba2efd29a7cb8b4258";
          "0.12.0" = "b593d13bb43c94ce94b483c2858e53a9b811f6f10e1e0eedc61073bd90e58d9c";
          "0.13.0" = "8c8fe44ef0a9afc256d1e75ad5f448bb59b81aba149b8958f02f7b3a98f5d9b4";
          "0.14.0" = "a868059c8c6dd6ad45a205cca04084c652cfe1852e6df2d5aca036f6e5438380";
          "0.15.0" = "fda23c37fbacf7579f94d5e8f342d3a831140e9471b770782e83846117dd6596";
          "0.16.0" = "815e666b1e9560c959ca79f2e2c62dd138c73bd8e7d85551e00e136cfd9b6278";
          "0.17.0" = "6dd4f396a48ecdeea6f70fb97be6568d291a8cba9a763d2b880e1c523ea0c997";
          "0.17.3" = "8c15896f6686beb5c631a4459a3aa8392daccaab805ea899c9d14215074b60ef";
        };
        rulesPython.oldTag = "0.1.0";
        rulesPython.newTag = "0.6.0";
        # rulesPython.oldRef = rulesPython.tags.${rulesPython.oldTag};
        rulesPython.oldRef = "aa96a691d3a8177f3215b14b0edc9641787abaaa30363a080165d06ab65e1161";
        rulesPython.newRef = rulesPython.tags.${rulesPython.newTag};
        rulesPython.oldUrl = "https://github.com/bazelbuild/rules_python/releases/download/0.0.1/rules_python-0.0.1.tar.gz";
        rulesPython.newUrl = "https://github.com/bazelbuild/rules_python/archive/refs/tags/${rulesPython.newTag}.tar.gz";
        rulesPython.insertAfter = ''name = "rules_python"'';
        rulesPython.insertStripPrefix = ''strip_prefix = "rules_python-${rulesPython.newTag}",'';
      in
      ''
        # Pins 5.1.1, we've got 5.4.0
        rm -f .bazelversion

        substituteInPlace WORKSPACE \
          --replace "${rulesPython.oldRef}" "${rulesPython.newRef}" \
          --replace "${rulesPython.oldUrl}" "${rulesPython.newUrl}"
        sed -i 's/^.*rules_python-0.0.1.*$//' WORKSPACE
        sed -i '/${rulesPython.insertAfter}/a ${rulesPython.insertStripPrefix}' WORKSPACE 
      '';

    nativeBuildInputs = [
      setuptools
      wheel
      absl-py
    ];
    propagatedBuildInputs = [
      numpy
    ];
    bazel = bazel_5;

    # why does it not take a list?
    bazelTarget = "//tensorflow_io/... //tensorflow_io_gcs_filesystem/...";

    TF_NEED_CUDA = cudaSupport;
    CUDA_TOOLKIT_PATH = lib.optionalString cudaSupport "${cudatoolkit_joined}";
    CUDNN_INSTALL_PATH = lib.optionalString cudaSupport "${cudnn}";
    TF_CUDA_PATHS = lib.optionalString cudaSupport "${cudatoolkit_joined},${cudnn},${nccl}";
    TF_CUDA_VERSION = lib.optionalString cudaSupport "${lib.versions.majorMinor cudatoolkit.version}";
    TF_CUDNN_VERSION = lib.optionalString cudaSupport "${lib.versions.major cudnn.version}";
    TF_CUDA_COMPUTE_CAPABILITIES = lib.optionalString cudaSupport "${cudaFlags.cudaRealCapabilitiesCommaString}";

    bazelFlags = [
      # File "/build/output/external/org_tensorflow/third_party/gpus/cuda_configure.bzl", line 1444, column 40, in <toplevel>
      # remote_cuda_configure = repository_rule(
      "--experimental_repo_remote_exec"
    ];

    fetchAttrs = {
      sha256 = "";
    };

    buildAttrs = {
      preBuild = ''
        patchShebangs .
      '';
      installPhase = ''
        # TODO: cf. tf-probability or something
        # ...
        mv *.whl "$out"
      '';
    };
  };
in
buildPythonPackage {
  inherit pname version;

  src = bazel-wheel;

  meta = with lib; {
    description = "Dataset, streaming, and file system extensions maintained by TensorFlow SIG-IO";
    homepage = "https://www.tensorflow.org/io";
    license = licenses.asl20;
  };
}
