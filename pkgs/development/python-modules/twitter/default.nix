{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "twitter";
  version = "1.19.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-g7jSSEpsdEihGuHG9MJTNVFe6NyB272vEsvAocRo72U=";
  };

  nativeBuildInputs = [ setuptools-scm ];
  doCheck = false;

  meta = with lib; {
    description = "Twitter API library";
    license     = licenses.mit;
    maintainers = with maintainers; [ thoughtpolice ];
  };

}
