{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "xstatic";
  version = "1.0.3";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-QCVEzJ4XlIlEEFTwnIB4BOEV6iRpB96HwDVftPWjEmg=";
  };

  # no tests implemented
  doCheck = false;

  meta = with lib; {
    description = "Base packaged static files for python";
    homepage = "https://github.com/xstatic-py/xstatic";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}
