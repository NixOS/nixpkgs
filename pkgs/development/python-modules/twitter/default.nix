{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "twitter";
  version = "1.19.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a56ff9575fbd50a51ce91107dcb5a4c3fd00c2ba1bcb172ce538b0948d3626e6";
  };

  nativeBuildInputs = [ setuptools-scm ];
  doCheck = false;

  meta = with lib; {
    description = "Twitter API library";
    license     = licenses.mit;
    maintainers = with maintainers; [ thoughtpolice ];
  };

}
