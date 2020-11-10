{ lib, buildPythonApplication, fetchPypi, xcffib, pyyaml, click, i3ipc, marshmallow, cffi, xpybutil, pytestrunner }:


buildPythonApplication rec {
  pname = "flashfocus";
  version = "2.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1z20d596rnc7cs0rrd221gjn14dmbr11djv94y9p4v7rr788sswv";
  };

  nativeBuildInputs = [ pytestrunner ];
  propagatedBuildInputs = [ i3ipc xcffib click cffi xpybutil marshmallow pyyaml ];

  # Tests require access to a X session
  doCheck = false;

  pythonImportsCheck = [ "flashfocus" ];

  meta = with lib; {
    homepage = "https://github.com/fennerm/flashfocus";
    description = "Simple focus animations for tiling window managers";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ artturin ];
  };
}
