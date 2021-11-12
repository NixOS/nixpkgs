{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-setuptools";
  version = "57.4.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1y0vx949wx5w4ra854ykwvgmdcwsb6v7jk29m4x1l79857sa16al";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "setuptools-stubs" ];

  meta = with lib; {
    description = "Typing stubs for setuptools";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
