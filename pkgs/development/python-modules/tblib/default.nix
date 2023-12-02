{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "tblib";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-k2InkKCingTwNGRY+s4eFE3E0y9JNxTGw9/4Kkrbd+Y=";
  };

  meta = with lib; {
    description = "Traceback fiddling library. Allows you to pickle tracebacks.";
    homepage = "https://github.com/ionelmc/python-tblib";
    license = licenses.bsd2;
    maintainers = with maintainers; [ teh ];
  };
}
