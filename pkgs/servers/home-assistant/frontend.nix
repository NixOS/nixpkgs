{ lib, fetchPypi, buildPythonPackage, user-agents }:

buildPythonPackage rec {
  pname = "home-assistant-frontend";
  version = "20190427.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eb14e7be0ad591ad4623c67db752bc4eb4f4e43ce60bb0f6d1909e9ad9399d91";
  };

  propagatedBuildInputs = [ user-agents ];

  # no Python tests implemented
  doCheck = false;

  meta = with lib; {
    description = "Polymer frontend for Home Assistant";
    homepage = https://github.com/home-assistant/home-assistant-polymer;
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
