{ lib
, buildPythonApplication
, fetchFromGitHub
}:

buildPythonApplication rec {
  pname = "sipvicious";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "EnableSecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-O8/9Vz/u8BoF1dfGceOJdzPPYLfkdBp2DkwA5WQ3dgo=";
  };

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "sipvicious" ];

  meta = with lib; {
    description = " Set of tools to audit SIP based VoIP systems";
    homepage = "https://github.com/EnableSecurity/sipvicious";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
