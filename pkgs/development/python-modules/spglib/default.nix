{ lib, buildPythonPackage, fetchPypi, numpy, pytest, pyyaml }:

buildPythonPackage rec {
  pname = "spglib";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-HQgewi2kq0/DGY6URd2tbewiYcQ5J4MRUdk+OUImEKo=";
  };

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytest pyyaml ];

  # pytestCheckHook doesn't work
  # ImportError: cannot import name '_spglib' from partially initialized module 'spglib'
  checkPhase = ''
    pytest
  '';

  pythonImportsCheck = [ "spglib" ];

  meta = with lib; {
    description = "Python bindings for C library for finding and handling crystal symmetries";
    homepage = "https://spglib.github.io/spglib/";
    changelog = "https://github.com/spglib/spglib/raw/v${version}/ChangeLog";
    license = licenses.bsd3;
    maintainers = with maintainers; [ psyanticy ];
  };
}
