{
  lib,
  python3,
  fetchFromGitHub,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gorilla-cli";
  version = "0.0.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "gorilla-llm";
    repo = "gorilla-cli";
    rev = version;
    hash = "sha256-3h3QtBDKswTDL7zNM2C4VWiGCqknm/bxhP9sw4ieIcQ=";
  };

  disabled = python3.pythonOlder "3.6";

  propagatedBuildInputs = with python3.pkgs; [
    requests
    halo
    prompt-toolkit
  ];

  passthru.updateScript = nix-update-script { };

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "LLMs for your CLI";
    homepage = "https://github.com/gorilla-llm/gorilla-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
    mainProgram = "gorilla";
  };
}
