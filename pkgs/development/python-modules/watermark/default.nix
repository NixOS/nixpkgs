{ lib
, fetchFromGitHub
, buildPythonPackage
, importlib-metadata
, ipython
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "watermark";
  version = "2.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rasbt";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-E3UxdGlxTcvkiKa3RoG9as6LybyW+QrCUZvA9VHwxlk=";
  };

  propagatedBuildInputs = [
    ipython
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs =  [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "watermark"
  ];

  meta = with lib; {
    description = "IPython extension for printing date and timestamps, version numbers, and hardware information";
    homepage = "https://github.com/rasbt/watermark";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nphilou ];
  };
}
