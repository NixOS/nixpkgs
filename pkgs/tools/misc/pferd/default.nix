{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "pferd";
  version = "3.2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Garmelon";
    repo = "PFERD";
    rev = "v${version}";
    sha256 = "0r75a128r8ghrccc1flmpxblfrab5kg6fypzrlfmv2aqhkqg1brb";
  };

  propagatedBuildInputs = with python3Packages; [
    aiohttp
    beautifulsoup4
    rich
    keyring
    certifi
  ];

  meta = with lib; {
    homepage = "https://github.com/Garmelon/PFERD";
    description = "Tool for downloading course-related files from ILIAS";
    license = licenses.mit;
    maintainers = with maintainers; [ _0xbe7a ];
  };
}
