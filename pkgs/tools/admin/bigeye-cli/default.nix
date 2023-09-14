{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "bigeye-cli";
  version = "0.3.42";
  format = "pyproject";

  src = fetchPypi {
    pname = "bigeye_cli";
    inherit version;
    hash = "sha256-NcSOnsEvyrqGmoFXiqdLCPoC62/Hwd2waiWtMwevUqY=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    typer
    importlib-metadata
    bigeye-sdk
    # (pydantic-yaml.overrideAttrs(_: { version = "0.8.1"; }))
  ];

  meta = with lib; {
    homepage = "https://pypi.org/project/bigeye-cli/";
    description = "Offers developer tools for maintaining your developer workspace.";
    mainProgram = "bigeye";
    license = licenses.gpl2;
    maintainers = with maintainers; [ sree ];
  };
}
