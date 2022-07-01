{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "edir";
  version = "2.7.3";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "06nsy9ikljc437368l38hsw75whacn3j6jwmdgg766q61pnifhkp";
  };

  meta = with lib; {
    description = "Program to rename and remove files and directories using your editor";
    homepage = "https://github.com/bulletmark/edir";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ guyonvarch ];
    platforms = platforms.all;
  };
}
