{ lib, fetchPypi, buildPythonPackage, pythonOlder }:

buildPythonPackage rec {
  pname = "vaa";
  version = "0.2.1";

  src = fetchPypi {
    inherit version pname;
    sha256 = "sha256-VaRBnYsJSqz/uC10iwmr5co1/mA2devat1cTc+fTv4o=";
  };

  doCheck = false;

  meta = with lib; {
    description =
      "Validators Adapter. The common interface for all validators in deal.";
    homepage = "https://github.com/life4/vaa";
    license = licenses.mit;
  };
}
