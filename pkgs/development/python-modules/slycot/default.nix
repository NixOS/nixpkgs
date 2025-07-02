{
  lib,
  blas,
  buildPythonPackage,
  cmake,
  fetchFromGitHub,
  gfortran,
  lapack,
  ninja,
  numpy,
  pytestCheckHook,
  pytest-timeout,
  python,
  scikit-build-core,
  scipy,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "slycot";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "python-control";
    repo = "slycot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NOoxgOCng6fTaRP+oTS4aoQlHES8ZwD8iKYJ3CS1waQ=";
    fetchSubmodules = true;
  };

  build-system = [
    ninja
    scikit-build-core
    setuptools-scm
  ];
  pyproject = true;
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    gfortran
  ];

  buildInputs = [
    blas
    lapack
  ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    pytest-timeout
    pytestCheckHook
    scipy
  ];

  postInstall = ''
    pythonRemoveTestsDir
  '';

  preCheck = ''
    rm -rf slycot
  '';

  pytestFlags = [
    "--pyargs"
    "slycot"
  ];

  pythonImportsCheck = [ "slycot" ];

  meta = {
    description = "Python wrapper for included SLICOT Fortran library";
    changelog = "https://github.com/python-control/slycot/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/python-control/slycot";
    license = with lib.licenses; [
      gpl2Only # slycot wrapper
      bsd3 # Fortran SLICOT library
      gpl3Plus # GPL-3.0 for the GCC-exception runtime parts
      bsd2 # BSD-2-Clause for specific build utilities
    ];
    maintainers = with lib.maintainers; [ Peter3579 ];
  };
})
