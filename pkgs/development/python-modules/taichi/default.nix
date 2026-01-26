{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  autoPatchelfHook,
  versionCheckHook,
  autoAddDriverRunpath,
  llvmPackages_15,
  cmake,
  ninja,
  setuptools,
  wheel,
  pybind11,
  scikit-build,
  git,
  pythonImportsCheckHook,
  pythonCatchConflictsHook,

  colorama,
  dill,
  matplotlib,
  numpy,
  rich,

  cudaPackages,
  elfutils,
  libbfd,
  libdwarf,
  libffi,
  libGL,
  libX11,
  libXrandr,
  libXinerama,
  libXcursor,
  libXi,
  libxml2,
  vulkan-headers,
  vulkan-loader,

  gtest,
  pytest,

  config,
  cudaSupport ? config.cudaSupport,
  rocmSupport ? config.rocmSupport,
  stdenv,
  enableMetal ? stdenv.isDarwin,
  enableOpenGL ? stdenv.isLinux,
  enableVulkan ? stdenv.isLinux,
}:
let
  pname = "taichi";
  version = "1.7.3";
  src = fetchFromGitHub {
    owner = "taichi-dev";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-QWtxPgR8RGnIEpbGO18Y8TFNhbKd4pOi9VLEkK2nhfk=";
    fetchSubmodules = true;
    # leaveDotGit = true;
  };

  llvmPackages = llvmPackages_15;
  libllvm = llvmPackages.libllvm;
  stdenv = llvmPackages.stdenv;

  platformLibs =
    lib.optionals cudaSupport [ cudaPackages.cudatoolkit ]
    ++ lib.optionals enableMetal [ ]
    ++ lib.optionals rocmSupport [ ]
    ++ lib.optionals enableVulkan [
      vulkan-loader
      vulkan-headers
    ]
    ++ lib.optionals enableOpenGL [ libGL ];

  # If the flag is a boolean, we'll pass "ON" or "OFF" to CMake.
  # Otherwise, we'll pass the value of the flag.
  cmakeFlag =
    cflag: flag:
    "-D" + cflag + "=" + (if (lib.typeOf flag == "bool") then (if flag then "ON" else "OFF") else flag);

  cmakeFlags = lib.attrsets.mapAttrsToList (name: value: (cmakeFlag name value)) {
    TI_BUILD_EXAMPLES = true;
    TI_BUILD_RHI_EXAMPLES = true;
    TI_BUILD_TESTS = true;
    TI_WITH_BACKTRACE = stdenv.isLinux;
    TI_WITH_C_API = true;
    TI_WITH_GGUI = true;
    TI_WITH_STATIC_C_API = with stdenv; (isDarwin && isAarch64);
    TI_WITH_PYTHON = true;
    TI_WITH_AMDGPU = rocmSupport;
    TI_WITH_CUDA = cudaSupport;
    TI_WITH_CUDA_TOOLKIT = false;
    TI_WITH_LLVM = true;
    TI_WITH_METAL = enableMetal;
    TI_WITH_OPENGL = enableOpenGL;
    TI_WITH_VULKAN = enableVulkan;

    # Should be resolved with buildinputs, not as a flag!
    LIBDWARF_INCLUDE_DIR = "${lib.getInclude libdwarf}/include";
  };

  # The echos are for debugging purposes
  # Can be removed later
  preConfigure = ''
    echo "CUDA:   ${builtins.toString cudaSupport}"
    echo "Metal:  ${builtins.toString enableMetal}"
    echo "ROCm:   ${builtins.toString rocmSupport}"

    echo "OpenGL: ${builtins.toString enableOpenGL}"
    echo "Vulkan: ${builtins.toString enableVulkan}"

    echo "Platform libs: ${builtins.toString platformLibs}"

    git init
    git config user.email "you@example.com"
    git commit -m "initial commit" --allow-empty
    git describe --match=DummyTagNotExisting --always --abbrev=40 --dirty
    # echo "${src.gitRepoUrl}"
    # git clone --no-checkout --depth 1 --branch ${src.tag} ${src.gitRepoUrl} ./tmp
    # cp -t ./tmp/.git .
    # rm -rf ./tmp
  '';

  taichi = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      cmakeFlags
      preConfigure
      ;

    propagatedNativeBuildInputs = [
      autoPatchelfHook
      cmake
      pybind11
      git
    ] ++ lib.optionals cudaSupport [ autoAddDriverRunpath ];

    propagatedBuildInputs = [
      elfutils
      libbfd
      libdwarf
      libdwarf.dev
      libffi.dev
      libxml2.dev

      libX11
      libXrandr
      libXinerama
      libXcursor
      libXi

      libllvm
    ] ++ platformLibs;

    # See https://github.com/NixOS/nixpkgs/issues/144170
    # Taken from original PR,
    # maybe this is more future proof:
    # https://github.com/NixOS/nixpkgs/issues/144170#issuecomment-1423195220
    postPatch = ''
      substituteInPlace \
        external/SPIRV-Headers/SPIRV-Headers.pc.in \
        external/SPIRV-Cross/pkg-config/spirv-cross-c-shared.pc.in \
        external/SPIRV-Tools/cmake/SPIRV-Tools.pc.in \
        external/SPIRV-Tools/cmake/SPIRV-Tools-shared.pc.in \
        --replace-warn '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@  \
        --replace-warn '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
    '';

    doCheck = true;
    nativeCheckInputs = [ gtest ];
  };
in
buildPythonPackage {
  inherit
    pname
    version
    src
    cmakeFlags
    stdenv
    preConfigure
    ;

  nativeBuildInputs =
    [
      ninja
      numpy
      scikit-build
      setuptools
      wheel
    ]
    ++ lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [
      pythonImportsCheckHook
      pythonCatchConflictsHook
    ];

  buildInputs = [
    taichi
  ];

  dependencies = [
    colorama
    dill
    matplotlib
    numpy
    rich
  ];

  postConfigure = ''
    cd ..
  '';

  # This is needed for the libraries like opengl and vulkan to be found at runtime
  preInstallCheck = ''
    shopt -s globstar

    for file in $out/**/*.so; do
      patchelf --add-rpath "${lib.makeLibraryPath platformLibs}" "$file"
    done
  '';

  dontUseNinjaCheck = true;

  nativeCheckInputs = [ pytest ];
  nativeInstallCheckInputs = [ versionCheckHook ];

  pythonImportsCheck = [ "taichi" ];

  meta = {
    description = "Productive & portable high-performance programming in Python";
    homepage = "https://github.com/taichi-dev/taichi";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ arunoruto ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "ti";
  };
}
