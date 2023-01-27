{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "edir";
  version = "2.16";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "ro1GZkJ6xDZcMRaWTAW/a2qhFbZAxsduvGO3C4sOI+A=";
  };

  meta = with lib; {
    description = "Program to rename and remove files and directories using your editor";
    homepage = "https://github.com/bulletmark/edir";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ guyonvarch ];
    platforms = platforms.all;
  };
}
