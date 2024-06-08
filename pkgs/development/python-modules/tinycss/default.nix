{
  lib,
  buildPythonPackage,
  cssutils,
  cython,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "tinycss";
  version = "0.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EjBvtQ5enn6u74S4Au2HdIi6gONcZyhn9UjAkkp2cW4=";
  };

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
  '';

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [ cssutils ];

  nativeCheckInputs = [ pytestCheckHook ];

  preBuild = ''
    # Force Cython to re-generate this file. If it is present, Cython will
    # think it is "up to date" even though it was generated with an older,
    # incompatible version of Cython. See
    # https://github.com/Kozea/tinycss/issues/17.
    rm tinycss/speedups.c
  '';

  # Disable Cython tests
  TINYCSS_SKIP_SPEEDUPS_TESTS = true;

  pythonImportsCheck = [ "tinycss" ];

  meta = with lib; {
    description = "Complete yet simple CSS parser for Python";
    homepage = "https://tinycss.readthedocs.io";
    changelog = "https://github.com/Kozea/tinycss/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
