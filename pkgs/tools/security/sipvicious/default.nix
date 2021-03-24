{ lib
, buildPythonApplication
, fetchFromGitHub
}:

buildPythonApplication rec {
  pname = "sipvicious";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "EnableSecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hna4xyjhdwi6z2aqqp25ydkb1qznlil95w2iqrr576wcrciznd5";
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
