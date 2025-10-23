{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

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
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dofuuz";
    repo = "python-soxr";
    tag = "v${version}";
    hash = "sha256-8NVQD1LamIRe77bKEs8YqHXeXifdMJpQUedmeiBRHSI=";
  };

  patches = [ ./cmake-nanobind.patch ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  dontUseCmakeConfigure = true;

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_LIBSOXR" true)
  ];

  build-system = [
    scikit-build-core
    nanobind
    setuptools
    setuptools-scm
  ]
  ++ lib.optionals (pythonOlder "3.11") [
    typing-extensions
  ];

  buildInputs = [ libsoxr ];

  dependencies = [ numpy ];

  pythonImportsCheck = [ "soxr" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    changelog = "https://github.com/dofuuz/python-soxr/releases/tag/${src.tag}";
    description = "High quality, one-dimensional sample-rate conversion library";
    homepage = "https://github.com/dofuuz/python-soxr/tree/main";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ hexa ];
  };
}
