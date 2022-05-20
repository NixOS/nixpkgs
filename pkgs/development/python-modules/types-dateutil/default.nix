{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-python-dateutil";
  version = "2.8.16";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OqrEwTjra47LwlUJluwl1uRbXTKIfR5pPQhC7i+mWdI=";
  };

  pythonImportsCheck = [ "dateutil-stubs" ];

  meta = with lib; {
    description = "Typing stubs for python-dateutil";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ milibopp ];
  };
}
