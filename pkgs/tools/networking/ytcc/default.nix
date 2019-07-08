{ lib, python3Packages, fetchFromGitHub, gettext }:

python3Packages.buildPythonApplication rec {
  pname = "ytcc";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "woefe";
    repo = "ytcc";
    rev = "v${version}";
    sha256 = "080p145j5pg8db88kb0y3x1pfc3v4aj3w68pdihlmi68dhjdr7i7";
  };

  doCheck = false; # try to access /homeless-shelter
  propagatedBuildInputs = with python3Packages; [ feedparser lxml sqlalchemy youtube-dl ];

  nativeBuildInputs = [ gettext ];

  meta = {
    description = "Command Line tool to keep track of your favourite YouTube channels without signing up for a Google account";
    homepage = "https://github.com/woefe/ytcc";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ marius851000 ];
  };
}
