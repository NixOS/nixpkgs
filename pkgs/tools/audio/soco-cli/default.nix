{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "soco-cli";
  version = "0.4.21";
  format = "setuptools";

  disabled = python3.pythonOlder "3.6";

  src = fetchFromGitHub rec {
    owner = "avantrec";
    repo = pname;
    rev = "v${version}";
    sha256 = "1kz2zx59gjfs01jiyzmps8j6yca06yqn6wkidvdk4s3izdm0rarw";
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
  };
}
