{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "pferd";
  version = "3.4.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Garmelon";
    repo = "PFERD";
    rev = "v${version}";
    sha256 = "1nwrkc0z2zghy2nk9hfdrffg1k8anh3mn3hx31ql8xqwhv5ksh9g";
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
