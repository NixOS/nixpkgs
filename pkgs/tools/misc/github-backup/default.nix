{ lib
, python3
, fetchPypi
, git
, git-lfs
}:

python3.pkgs.buildPythonApplication rec {
  pname = "github-backup";
  version = "0.45.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wn2JRMLfqhhTREeYM+mcs68xlkRWKMlxKXToa83pu2g=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ git git-lfs ])
  ];

  # has no unit tests
  doCheck = false;

  meta = with lib; {
    description = "Backup a github user or organization";
    homepage = "https://github.com/josegonzalez/python-github-backup";
    changelog = "https://github.com/josegonzalez/python-github-backup/blob/${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
    mainProgram = "github-backup";
  };
}
