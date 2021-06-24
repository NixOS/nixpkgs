{ lib
, buildPythonApplication
, fetchFromGitHub
}:

buildPythonApplication rec {
  pname = "sipvicious";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "EnableSecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "17f6w7qh33zvlhqwf22y9y7skha0xjs46yk66q8xm4brsv4lfxxa";
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
