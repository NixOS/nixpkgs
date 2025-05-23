{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonOlder,
  snappy-manifolds,
}:

buildPythonPackage rec {
  pname = "snappy-15-knots";
  version = "1.2.1";

  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    pname = "snappy_15_knots";
    inherit version;
    sha256 = "sha256-LH+7+oJ6YskOn3ogvFxcF02s6/4klQ8LgN8Zn6QUzVw=";
  };

  build-system = [ setuptools ];

  doCheck = true;

  propagatedBuildInputs = [ snappy-manifolds ];

  pythonImportsCheck = [ "snappy_15_knots" ];

  meta = with lib; {

    description = "Database of snappy manifolds";
    homepage = "https://snappy.computop.org";
    license = licenses.gpl2;
    maintainers = with maintainers; [ noiioiu ];
  };
}
