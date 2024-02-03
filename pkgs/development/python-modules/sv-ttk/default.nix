{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sv-ttk";
  version = "2.5.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "sv_ttk";
    hash = "sha256-m7/iq6bMb5/fcNeTMQRlQ8lmb8zMeLrV/2SKmYfjzts=";
  };

  # No tests available
  doCheck = false;

  pythonImportsCheck = [
    "sv_ttk"
  ];

  meta = with lib; {
    description = "A gorgeous theme for Tkinter/ttk, based on the Sun Valley visual style";
    homepage = "https://github.com/rdbende/Sun-Valley-ttk-theme";
    changelog = "https://github.com/rdbende/Sun-Valley-ttk-theme/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ AngryAnt ];
  };
}
