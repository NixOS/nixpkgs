{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "soco-cli";
  version = "0.4.55";
  format = "setuptools";

  disabled = python3.pythonOlder "3.6";

  src = fetchFromGitHub rec {
    owner = "avantrec";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zdu1eVtVBTYa47KjGc5fqKN6olxp98RoLGT2sNCfG9E=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    fastapi
    rangehttpserver
    soco
    tabulate
    uvicorn
  ];

  # Tests wants to communicate with hardware
  doCheck = false;

  pythonImportsCheck = [
    "soco_cli"
  ];

  meta = with lib; {
    description = "Command-line interface to control Sonos sound systems";
    homepage = "https://github.com/avantrec/soco-cli";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "sonos";
  };
}
