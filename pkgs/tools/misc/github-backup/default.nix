{ lib
, python3
, git
, git-lfs
}:

python3.pkgs.buildPythonApplication rec {
  pname = "github-backup";
  version = "0.39.0";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "71829df4bdbe5bd55c324a97008405a6b4c6113edb1a2a6a8b73a7059fe64a47";
  };

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
  };
}
