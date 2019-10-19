{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "home-assistant-frontend";
  version = "20190919.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xdw8fj4njc3sf15mlyiwigrwf89xsz4r2dsv6zs5fnl512r439a";
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
