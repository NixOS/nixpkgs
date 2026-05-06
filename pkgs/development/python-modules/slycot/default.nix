{
  lib,
  blas,
  buildPythonPackage,
  cmake,
  fetchFromGitHub,
  gfortran,
  lapack,
  numpy,
  numpydoc,
  pytestCheckHook,
  pytest-timeout,
  python,
  pythonOlder,
  scikit-build,
  scipy,
  setuptools,
  setuptools-scm,
  wheel,
}:

buildPythonPackage rec {
  pname = "slycot";
  version = "0.6.1";
  disabled = pythonOlder "3.10";
  pyproject = true;
  dontUseCmakeConfigure = true;

  src = fetchFromGitHub {
    owner = "python-control";
    repo = "slycot";
    tag = "v${version}";
    hash = "sha256-shofqk2pGQjn34zY3nCM61sCTeOTkoNvHMZsUkOfJGE=";
  };

  slicotReference = fetchFromGitHub {
    # patched version of SLICOT-Reference v5.9
    owner = "python-control";
    repo = "SLICOT-Reference";
    rev = "795051cbc2a1d4766753e9ab3bac13eaf731f8d6";
    hash = "sha256-32p0cdISZiDwi7HxaBYJF01IAiMnF2NJpJaNQYVyWY4=";
  };

  postPatch = ''
    ln -sfn ${slicotReference}/src slycot/src/SLICOT-Reference
  '';

  build-system = [
    scikit-build
    setuptools
    setuptools-scm
    wheel
    cmake
    gfortran
  ];

  dependencies = [
    numpy
    scipy
    blas
    lapack
  ];

  pythonImportsCheck = [ "slycot" ];

  nativeCheckInputs = [
    pytest-timeout
    pytestCheckHook
  ];

  pytestFlagsArray = [ "${placeholder "out"}/${python.sitePackages}/slycot/tests" ];

  meta = {
    description = "Python wrapper for included SLICOT Fortran library";
    changelog = "https://github.com/python-control/slycot/releases/tag/${src.tag}";
    homepage = "https://github.com/python-control/slycot";
    license = [
      lib.licenses.gpl2Only # slycot wrapper
      lib.licenses.bsd3 # Fortran SLICOT library
    ];
    maintainers = with lib.maintainers; [ Peter3579 ];
  };
}
