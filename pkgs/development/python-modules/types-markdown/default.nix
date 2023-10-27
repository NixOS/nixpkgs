{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-markdown";
  version = "3.5.0.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "types-Markdown";
    inherit version;
    hash = "sha256-jC9VJruin+7iQEDUaUztVU0JrkbR8VI7K3OVWL6rrkI=";
  };

  # Modules has no tests
  doCheck = false;

  pythonImportsCheck = [
    "markdown-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for Markdown";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ elohmeier ];
  };
}
