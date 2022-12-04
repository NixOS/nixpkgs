{ lib
, buildPythonPackage
, cython
, fetchFromGitHub
, ply
, pythonOlder
, six
, tornado
}:

buildPythonPackage rec {
  pname = "thriftpy2";
  version = "0.4.15";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Thriftpy";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-1X1roRFQgLJ+rrRuRlHMVtUdj2D68WGdxvid/0chsvI=";
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

  pythonImportsCheck = [
    "thriftpy2"
  ];

  meta = with lib; {
    description = "Python module for Apache Thrift";
    homepage = "https://github.com/Thriftpy/thriftpy2";
    changelog = "https://github.com/Thriftpy/thriftpy2/blob/v${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
