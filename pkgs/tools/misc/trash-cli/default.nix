{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "trash-cli";
  version = "0.21.4.18";

  src = fetchFromGitHub {
    owner = "andreafrancia";
    repo = "trash-cli";
    rev = version;
    sha256 = "16xmg2d9rfmm5l1dxj3dydijpv3kwswrqsbj1sihyyka4s915g61";
  };

  propagatedBuildInputs = [ python3Packages.psutil ];

  checkInputs = with python3Packages; [
    mock
    pytest
  ];

  # Run tests, skipping `test_user_specified` since its result depends on the
  # mount path.
  checkPhase = ''
    pytest -k 'not test_user_specified'
  '';

  meta = with lib; {
    homepage = "https://github.com/andreafrancia/trash-cli";
    description = "Command line tool for the desktop trash can";
    maintainers = [ maintainers.rycee ];
    platforms = platforms.unix;
    license = licenses.gpl2;
    mainProgram = "trash";
  };
}
