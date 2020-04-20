{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, setuptools
, lazr-uri
}:

buildPythonPackage rec {
  pname = "wadllib";
  version = "1.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1234cfe81e2cf223e56816f86df3aa18801d1770261865d93337b8b603be366e";
  };

  propagatedBuildInputs = [ setuptools lazr-uri ];

  doCheck = isPy3k;

  meta = with lib; {
    description = "Navigate HTTP resources using WADL files as guides";
    homepage = "https://launchpad.net/wadllib";
    license = licenses.lgpl3;
    maintainers = [ maintainers.marsam ];
  };
}
