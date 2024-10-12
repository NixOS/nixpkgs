{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  tkinter,
}:

buildPythonPackage rec {
  pname = "sv-ttk";
  version = "2.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "sv_ttk";
    hash = "sha256-P9RAOWyV4w6I9ob88ovkJUgPcyDWvzRvnOpdb1ZwLMI=";
  };

  # No tests available
  doCheck = false;

  propagatedBuildInputs = [ tkinter ];

  pythonImportsCheck = [ "sv_ttk" ];

  meta = with lib; {
    description = "Gorgeous theme for Tkinter/ttk, based on the Sun Valley visual style";
    homepage = "https://github.com/rdbende/Sun-Valley-ttk-theme";
    changelog = "https://github.com/rdbende/Sun-Valley-ttk-theme/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ AngryAnt ];
  };
}
