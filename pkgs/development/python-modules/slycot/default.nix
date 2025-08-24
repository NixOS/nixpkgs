{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  numpy,
  scipy,
  scikit-build,
  setuptools,
  setuptools-scm,
  wheel,
  cmake,
  gfortran,
  blas,
  lapack,
  pytestCheckHook,
  python,
}:

buildPythonPackage rec {
  pname = "slycot";
  version = "0.6.0";
  disabled = pythonOlder "3.10";
  pyproject = true;
  dontUseCmakeConfigure = true;

  src = fetchFromGitHub {
    owner = "python-control";
    repo = "slycot";
    tag = "v${version}";
    hash = "sha256-80JerCqd316PXcmcNA7Cu+W3HjNF3rTPjUA3s1rCaRA=";
  };

  slicotReference = fetchFromGitHub {
    owner = "SLICOT";
    repo = "SLICOT-Reference";
    tag = "v5.9";
    hash = "sha256-BblRLDQVPdzjQseFXnSzgAbAecd+AUA/k/zSRATMVeQ=";
  };

  postPatch = ''
    substituteInPlace slycot/CMakeLists.txt \
      --replace-fail 'src/SLICOT-Reference/src/SLCT_DLATZM.f' '# src/SLICOT-Reference/src/SLCT_DLATZM.f' \
      --replace-fail 'src/SLICOT-Reference/src/SLCT_ZLATZM.f' '# src/SLICOT-Reference/src/SLCT_ZLATZM.f'
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

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "${placeholder "out"}/${python.sitePackages}/slycot/tests" ];

  disabledTests = [
    # these fail, might be related to upstream issue #222 with td04ad
    "test_staticgain"
    "test_td04ad_static"
    "test_mixfeedthrough"
    "test_tfm2ss_6"
  ];

  meta = {
    changelog = "https://github.com/python-control/slycot/releases/tag/${src.tag}";
    description = "Python wrapper for included SLICOT Fortran library";
    homepage = "https://github.com/python-control/slycot";
    license = [
      lib.licenses.gpl2Only # slycot wrapper
      lib.licenses.bsd3 # Fortran SLICOT library
    ];
    maintainers = with lib.maintainers; [ Peter3579 ];
  };
}
