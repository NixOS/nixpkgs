{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "trash-cli";
  version = "0.20.11.23";

  src = fetchFromGitHub {
    owner = "andreafrancia";
    repo = "trash-cli";
    rev = version;
    sha256 = "1fjkmpnbpzxniypql68cpwc2rrnih8b34p8pzabrf55f49wcmcph";
  };

  propagatedBuildInputs = [ python3Packages.psutil ];

  checkInputs = with python3Packages; [
    nose
    mock
  ];
  checkPhase = "nosetests";

  meta = with stdenv.lib; {
    homepage = "https://github.com/andreafrancia/trash-cli";
    description = "Command line tool for the desktop trash can";
    maintainers = [ maintainers.rycee ];
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
