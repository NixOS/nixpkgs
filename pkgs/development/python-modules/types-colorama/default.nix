{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-colorama";
  version = "0.4.15.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vENoegvz9CEVpWQAvVPGGFksxhHmb/V9XMlQJMtE+xo=";
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
