{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "trash-cli";
  version = "0.21.6.10.1";

  src = fetchFromGitHub {
    owner = "andreafrancia";
    repo = "trash-cli";
    rev = version;
    sha256 = "0mhpzf3vmd876aldl5gazmk4si0zvrh0v1rwsz2hbrn0571zmzy9";
  };

  propagatedBuildInputs = [ python3Packages.psutil ];

  checkInputs = with python3Packages; [
    mock
    pytestCheckHook
  ];

  # Skip `test_user_specified` since its result depends on the mount path.
  disabledTests = [ "test_user_specified" ];

  meta = with lib; {
    homepage = "https://github.com/andreafrancia/trash-cli";
    description = "Command line tool for the desktop trash can";
    maintainers = [ maintainers.rycee ];
    platforms = platforms.unix;
    license = licenses.gpl2;
    mainProgram = "trash";
  };
}
