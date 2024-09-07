{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wad";
  version = "0.4.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "CERN-CERT";
    repo = "WAD";
    rev = "v${version}";
    hash = "sha256-/mlmOzFkyKpmK/uk4813Wk0cf/+ynX3Qxafnd1mGR5k=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    six
  ];

  nativeCheckInputs = with python3.pkgs; [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "wad"
  ];

  meta = with lib; {
    description = "Tool for detecting technologies used by web applications";
    mainProgram = "wad";
    longDescription = ''
      WAD lets you analyze given URL(s) and detect technologies used by web
      application behind that URL, from the OS and web server level, to the
      programming platform and frameworks, as well as server- and client-side
      applications, tools and libraries.
    '';
    homepage = "https://github.com/CERN-CERT/WAD";
    # wad is GPLv3+, wappalyzer source is MIT
    license = with licenses; [ gpl3Plus mit ];
    maintainers = with maintainers; [ fab ];
  };
}
