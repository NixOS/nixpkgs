{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
}:

buildPythonPackage rec {
  pname = "std-uritemplate";
  version = "0.0.50";
  pyproject = true;

  src = fetchPypi {
    pname = "std_uritemplate";
    inherit version;
    hash = "sha256-ZeMNxtZm+rltW4pD9/46lHEVFdExSL7b5N02T3AYk+k=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  pythonImportsCheck = [ "stduritemplate" ];

  # tests not shipped on PyPI, no tags on GitHub
  doCheck = false;

  meta = {
    description = "Std-uritemplate implementation for Python";
    homepage = "https://github.com/andreaTP/std-uritemplate";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
