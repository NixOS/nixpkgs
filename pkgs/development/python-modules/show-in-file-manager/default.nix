{ lib, buildPythonPackage, fetchPypi, pyxdg, packaging }:

buildPythonPackage rec {
  pname = "show-in-file-manager";
  version = "1.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nrsmdms4zhhkqyggqs5srm4l340qclz00ld0dxj37jvhx56xl8m";
  };

  buildInputs = [ pyxdg packaging ];

  meta = with lib; {
    homepage = "https://github.com/damonlynch/showinfilemanager/";
    description = "A library to open the system file manager and optionally select files in it";
    license = licenses.mit;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
