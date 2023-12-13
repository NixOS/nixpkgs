{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-colorama";
  version = "0.4.15.12";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+9/F2dJNhcM70FT74zrcbOxE7tsZz7ur+7tX3CV65Lg=";
  };

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Typing stubs for colorama";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
