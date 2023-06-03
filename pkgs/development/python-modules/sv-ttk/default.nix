{ lib
, buildPythonPackage
, fetchPypi
}:
buildPythonPackage rec {
  pname = "sv-ttk";
  version = "2.4.5";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "sv_ttk";
    hash = "sha256-ysRhRxrml+wmluH8F5AE7vZYXrTNUg5ZzI+26jwpOpc=";
  };

  # No tests available
  doCheck = false;
  pythonImportsCheck = [ "sv_ttk" ];

  meta = with lib; {
    description = "A gorgeous theme for Tkinter/ttk, based on the Sun Valley visual style";
    homepage = "https://github.com/rdbende/Sun-Valley-ttk-theme";
    changelog = "https://github.com/rdbende/Sun-Valley-ttk-theme/releases";
    license = licenses.mit;
    maintainers = with maintainers; [ AngryAnt ];
  };
}
