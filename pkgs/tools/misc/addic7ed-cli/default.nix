{ lib
, python3Packages
, fetchPypi
}:

python3Packages.buildPythonApplication rec {
  pname = "addic7ed-cli";
  version = "1.4.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xWGAsUWlPtghiXkmErqleMm9tQcF6WsDfXr5dju/TKA=";
  };

  propagatedBuildInputs = with python3Packages; [
    requests
    pyquery
  ];

  # Tests require network access
  doCheck = false;
  pythonImportsCheck = [ "addic7ed_cli" ];

  meta = with lib; {
    description = "Commandline access to addic7ed subtitles";
    homepage = "https://github.com/BenoitZugmeyer/addic7ed-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ aethelz ];
    platforms = platforms.unix;
    mainProgram = "addic7ed";
  };
}
