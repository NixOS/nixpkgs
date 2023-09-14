{ lib
, python3
, fetchPypi
}:
python3.pkgs.buildPythonApplication rec {
  pname = "bigeye_cli";
  version = "0.3.42";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NcSOnsEvyrqGmoFXiqdLCPoC62/Hwd2waiWtMwevUqY=";
  };

  meta = with lib; {
    homepage = "https://pypi.org/project/bigeye-cli/";
    description = "Bigeye CLI offers developer tools for maintaining your developer workspace.";
    mainProgram = "bigeye";
    maintainers = with maintainers; [ ];
  };
}
