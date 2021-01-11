{ lib, stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "trash-cli";
  version = "0.20.12.26";

  src = fetchFromGitHub {
    owner = "andreafrancia";
    repo = "trash-cli";
    rev = version;
    sha256 = "15iivl9xln1bw1zr2x5zvqyb6aj7mc8hfqi6dniq6xkp5m046ib7";
  };

  propagatedBuildInputs = [ python3Packages.psutil ];

  checkInputs = with python3Packages; [
    nose
    mock
  ];
  checkPhase = "nosetests";

  meta = with lib; {
    homepage = "https://github.com/andreafrancia/trash-cli";
    description = "Command line tool for the desktop trash can";
    maintainers = [ maintainers.rycee ];
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
