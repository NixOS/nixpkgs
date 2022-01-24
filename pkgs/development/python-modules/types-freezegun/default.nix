{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-freezegun";
  version = "1.1.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XHCkt0RLjH3SgA4AY9b+chqxEgk5kmT6D3evJT3YsU8=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "freezegun-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for freezegun";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
