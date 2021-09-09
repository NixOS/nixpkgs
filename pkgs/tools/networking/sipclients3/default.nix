{ lib, python3, fetchdarcs }:

python3.pkgs.buildPythonApplication rec {
  pname = "sipclients3";
  version = "5.2.3";

  src = fetchdarcs {
    url = "http://devel.ag-projects.com/repositories/sipclients3";
    rev = version;
    sha256 = "sha256-ejx9/+EGWoQ5/J147YX1tK+l00uzgKTOxIYmz2o4j6c=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    python3-application
    python3-eventlib
    python3-sipsimple
    requests
    twisted
    zope_interface
  ];

  pythonImportsCheck = [ "sipclient" "sipclient.configuration" ];

  meta = with lib; {
    homepage = "https://sipsimpleclient.org/testing/";
    description = "SIP SIMPLE Command Line Clients";
    longDescription = ''
      This package contains Command Line Clients for testing SIP SIMPLE client
      SDK from http://sipsimpleclient.org. They demonstrate the SDK capabilities
      and can be used as examples or for testing purposes.
    '';
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ chanley ];
  };
}
