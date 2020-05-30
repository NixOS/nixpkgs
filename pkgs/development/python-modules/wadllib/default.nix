{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, setuptools
, lazr-uri
}:

buildPythonPackage rec {
  pname = "wadllib";
  version = "1.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e995691713d3c795d2b36278de8e212241870f46bec6ecba91794ea3cc5bd67d";
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
