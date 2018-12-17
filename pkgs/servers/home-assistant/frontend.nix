{ lib, fetchPypi, buildPythonPackage, user-agents }:

buildPythonPackage rec {
  pname = "home-assistant-frontend";
  version = "20181211.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c3bb994e8e121d146fedc113b35ced0c007169fd70b489e9344df082f934dbdf";
  };

  propagatedBuildInputs = [ user-agents ];

  meta = with lib; {
    description = "Polymer frontend for Home Assistant";
    homepage = https://github.com/home-assistant/home-assistant-polymer;
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
