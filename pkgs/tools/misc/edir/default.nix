{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "edir";
  version = "2.29";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5b86/M8xqzwWMCRtsH1qwmooyfOhORgXgctRjzQEmlU=";
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
