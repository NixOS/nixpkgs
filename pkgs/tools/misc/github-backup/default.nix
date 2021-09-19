{ lib
, python3
, git
, git-lfs
}:

python3.pkgs.buildPythonApplication rec {
  pname = "github-backup";
  version = "0.40.0";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-HgNOTi4z1wbRdeVFjGVbpuxd9/o9aWWYd8/ykiVF8Ks=";
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
