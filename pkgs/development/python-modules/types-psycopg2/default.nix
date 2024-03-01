{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "types-psycopg2";
  version = "2.9.21.20240218";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MITNgHA4piyA+1vni0HYVbSKBgMWEB6ln9hcMC77V9Q=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "psycopg2-stubs"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Typing stubs for psycopg2";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
