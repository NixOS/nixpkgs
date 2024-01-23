{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "edir";
  version = "2.27";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-i9c5DDZnCj6Roqw6fpy+rhX2/Sup1hh8vIpsRcWZQFc=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools-scm
  ];

  propagatedBuildInputs = with python3Packages; [
    platformdirs
  ];

  meta = with lib; {
    description = "Program to rename and remove files and directories using your editor";
    homepage = "https://github.com/bulletmark/edir";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ guyonvarch ];
    platforms = platforms.all;
    mainProgram = "edir";
  };
}
