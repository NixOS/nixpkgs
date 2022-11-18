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
  version = "0.4.15";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Thriftpy";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-1X1roRFQgLJ+rrRuRlHMVtUdj2D68WGdxvid/0chsvI=";
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
