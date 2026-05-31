{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  nanobind,
  numpy,
  setuptools,

  # nativeBuildInputs
  cmake,
  llvm,
  ninja,
  nlohmann_json,
  writableTmpDirAsHomeHook,

  # buildInputs
  zlib,
}:
buildPythonPackage (finalAttrs: {
  pname = "tokenspeed-triton";
  version = "3.7.10.post20260531";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lightseekorg";
    repo = "triton";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xsV63z2NtB5BM0rF0J+cnMH2RYzoWkpsSXHQI2nIEdQ=";
  };

  patches = [
    ./no-git.patch
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "TRITON_VERSION = " "TRITON_VERSION = \"${finalAttrs.version}\" # "
  ''
  +
    # Allow CMake 4
    # Upstream issue: https://github.com/triton-lang/triton/issues/8245
    ''
      substituteInPlace pyproject.toml \
        --replace-fail "cmake>=3.20,<4.0" "cmake>=3.20" \
        --replace-fail "nanobind==2.10.2" "nanobind>=2.10.2"
    '';

  build-system = [
    nanobind
    numpy
    setuptools
  ];

  nativeBuildInputs = [
    cmake
    ninja

    # Upstream's setup.py tries to write cache somewhere in ~/
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    zlib
  ];

  dontUseCmakeConfigure = true;

  env = {
    TRITON_BUILD_PROTON = false;
    TRITON_OFFLINE_BUILD = true;
    LLVM_SYSPATH = llvm;
    JSON_SYSPATH = nlohmann_json;
  };

  meta = {
    description = "Language and compiler for writing highly efficient custom Deep-Learning primitives";
    homepage = "https://github.com/lightseekorg/triton";
    downloadPage = "https://github.com/lightseekorg/triton/releases";
    changelog = "https://github.com/lightseekorg/triton/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prince213 ];
    platforms = lib.platforms.linux;
  };
})
