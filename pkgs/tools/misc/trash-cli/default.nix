{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "trash-cli";
  version = "0.21.5.11";

  src = fetchFromGitHub {
    owner = "andreafrancia";
    repo = "trash-cli";
    rev = version;
    sha256 = "0ifv717ywq2y0s6m9rkry1fnsr3mg9n2b2zcwaf9r5cxpw90bmym";
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
