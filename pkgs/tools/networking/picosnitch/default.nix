{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "picosnitch";
  version = "0.9.0";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "e56aef62f0f9a48a346f02a96362b0e655cc754ebacaf58cb1632e602463d365";
  };

  propagatedBuildInputs = with python3.pkgs; [ psutil dbus-python requests ];

  pythonImportsCheck = [ "picosnitch" ];

  meta = with lib; {
    description = "Tool for Linux to help protect your privacy";
    homepage = "https://github.com/elesiuta/picosnitch";
    changelog = "https://github.com/elesiuta/picosnitch/releases";
    license = licenses.gpl3;
    maintainers = [ maintainers.j0hax ];
    platforms = platforms.linux;
  };
}
