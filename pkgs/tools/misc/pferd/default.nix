{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "pferd";
  version = "3.0.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Garmelon";
    repo = "PFERD";
    rev = "v${version}";
    sha256 = "1s0z8yajy3n194pnlqb48hy2n5qvhkzwbpksrdyds79vfq0b9rdl";
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
