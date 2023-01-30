{ lib
, stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "Yapsy";
  version = "1.12.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12rznbnswfw0w7qfbvmmffr9r317gl1rqg36nijwzsklkjgks4fq";
  };

  meta = with lib; {
    homepage = "https://yapsy.sourceforge.net/";
    description = "Yet another plugin system";
    license = licenses.bsd0;
    # tests fail and are not using pytest to easily disable them
    broken = stdenv.isDarwin;
  };
}
