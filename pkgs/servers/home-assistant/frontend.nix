{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "home-assistant-frontend";
  version = "20190719.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p7nf0jg2xl9cv020l00scxhv159yp38dkh4204f6am09npkfsps";
  };

  # no Python tests implemented
  doCheck = false;

  meta = with lib; {
    description = "Polymer frontend for Home Assistant";
    homepage = https://github.com/home-assistant/home-assistant-polymer;
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda globin ];
  };
}
