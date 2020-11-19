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
  version = "3.2.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f845868b3a3a77a2489d226568abe7328b5c2d4f6a011cc759dfa99144a521f0";
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
