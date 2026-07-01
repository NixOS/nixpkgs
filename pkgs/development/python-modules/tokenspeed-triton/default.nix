{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  cmake,
  nanobind,
  ninja,
  setuptools,

  # nativeBuildInputs
  writableTmpDirAsHomeHook,

  # buildInputs
  tokenspeed-triton-llvm,
  nlohmann_json,
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

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "TRITON_VERSION = " 'TRITON_VERSION = "${finalAttrs.version}" # '

    sed -i '/def is_git_repo()/a\\    return False' setup.py

    substituteInPlace pyproject.toml \
      --replace-fail "cmake>=3.20,<4.0" "cmake>=3.20" \
      --replace-fail "nanobind==2.10.2" "nanobind>=2.10.2"
  '';

  build-system = [
    cmake
    nanobind
    ninja
    setuptools
  ];

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ];

  # https://github.com/lightseekorg/triton/blob/v3.7.10.post20260531/.github/workflows/wheels.yml#L109-L117
  env = {
    TRITON_OFFLINE_BUILD = true;
    TRITON_BUILD_RELEASE = true;
    TRITON_BUILD_PROTON = false;
    TRITON_STABLE_ABI = pythonAtLeast "3.12";
    LLVM_SYSPATH = tokenspeed-triton-llvm;
    JSON_SYSPATH = nlohmann_json;
    NIX_CFLAGS_COMPILE = "-Wno-stringop-overflow";
  };

  buildInputs = [
    zlib
  ];

  pythonImportsCheck = [
    "tokenspeed_triton"
  ];

  # tests import triton instead of tokenspeed_triton
  doCheck = false;

  meta = {
    description = "Language and compiler for custom Deep Learning operations";
    homepage = "https://github.com/lightseekorg/triton";
    downloadPage = "https://pypi.org/project/tokenspeed-triton/#files";
    changelog = "https://github.com/lightseekorg/triton/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prince213 ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})
