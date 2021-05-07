{ stdenv, lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "torf-cli";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "rndusr";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ad6swad8wpvxlivbrydhjrgjl82xd6pppjl88c6xfkzndydp15c";
  };

  propagatedBuildInputs = with python3Packages; [ torf pyxdg ];

  doCheck = false;

  meta = with lib; {
    description = "CLI tool for creating, reading and editing torrent files";
    homepage = "https://github.com/rndusr/torf-cli";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ synthetica ];
  };
}
