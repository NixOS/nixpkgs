{ lib
, buildPythonPackage
, cython
, fetchFromGitHub
, pythonOlder
, ply
, six
, tornado
}:

buildPythonPackage rec {
  pname = "thriftpy2";
  version = "0.4.14";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Thriftpy";
    repo = pname;
    rev = "v${version}";
    sha256 = "17f57vsbym4c9yax128bhrwg2zjxcsgl3ja6422y8hyb38v5mdc3";
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    ply
    six
    tornado
  ];

  # Not all needed files seems to be present
  doCheck = false;

  pythonImportsCheck = [ "thriftpy2" ];

  meta = with lib; {
    description = "Python module for Apache Thrift";
    homepage = "https://github.com/Thriftpy/thriftpy2";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
