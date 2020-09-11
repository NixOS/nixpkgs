{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, importlib-metadata
, pbr
, setuptools
, six
}:

buildPythonPackage rec {
  pname = "stevedore";
  version = "3.2.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1r8m8g7f13wdmfw5m7k0vj7bcx3psfg5yg2i8jlb08nrpsjily9q";
  };

  propagatedBuildInputs = [ pbr setuptools six ]
    ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  doCheck = false;
  pythonImportsCheck = [ "stevedore" ];

  meta = with lib; {
    description = "Manage dynamic plugins for Python applications";
    homepage = "https://pypi.python.org/pypi/stevedore";
    license = licenses.asl20;
  };
}
