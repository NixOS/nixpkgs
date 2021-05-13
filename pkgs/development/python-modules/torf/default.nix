{ stdenv, lib, fetchFromGitHub, buildPythonPackage, pythonOlder, flatbencode
, pytest }:

buildPythonPackage rec {
  pname = "torf";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "rndusr";
    repo = pname;
    rev = "v${version}";
    sha256 = "0l9j45parz13xgsl40bf58zib0js6fs22fssx6x457q6drw7a2zg";
  };

  propagatedBuildInputs = [ flatbencode ];
  checkInputs = [ pytest ];

  disabled = pythonOlder "3.6";

  meta = with lib; {
    description =
      "Python module to create, parse and edit torrent files and magnet links";
    homepage = "https://github.com/rndusr/torf";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ synthetica ];
  };
}
