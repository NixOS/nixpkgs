{
  lib,
  apple-sdk_11,
  buildPythonPackage,
  darwinMinVersionHook,
  fetchFromGitHub,
  pythonOlder,
  stdenv,

  # build-system
  cmake,
  nanobind,
  ninja,
  scikit-build-core,
  setuptools,
  setuptools-scm,
  typing-extensions,

  # native dependencies
  libsoxr,

  # dependencies
  numpy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "soxr";
  version = "0.5.0.post1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dofuuz";
    repo = "python-soxr";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-Fpayc+MOpDUCdpoyJaIqSbMzuO0jYb6UN5ARFaxxOHk=";
  };

  patches = [ ./cmake-nanobind.patch ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  dontUseCmakeConfigure = true;

  pypaBuildFlags = [
    "--config=cmake.define.USE_SYSTEM_LIBSOXR=ON"
  ];

  build-system =
    [
      scikit-build-core
      nanobind
      setuptools
      setuptools-scm
    ]
    ++ lib.optionals (pythonOlder "3.11") [
      typing-extensions
    ];

  buildInputs =
    [ libsoxr ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # error: aligned deallocation function of type 'void (void *, std::align_val_t) noexcept' is only available on macOS 10.13 or newer
      (darwinMinVersionHook "10.13")
      apple-sdk_11
    ];

  dependencies = [ numpy ];

  pythonImportsCheck = [ "soxr" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "High quality, one-dimensional sample-rate conversion library";
    homepage = "https://github.com/dofuuz/python-soxr/tree/main";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ hexa ];
  };
}
