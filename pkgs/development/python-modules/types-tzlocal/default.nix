{
  lib,
  buildPythonPackage,
  fetchPypi,
  types-pytz,
}:

buildPythonPackage rec {
  pname = "types-tzlocal";
  version = "5.1.0.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uEoRXAxo8ND6mvHFfwZF7u8OU5FHgG+vH5WsOsAc5Hs=";
  };

  propagatedBuildInputs = [
    types-pytz
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "tzlocal-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for tzlocal";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ YorikSar ];
  };
}
