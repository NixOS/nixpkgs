{ lib
, python3
, git
, git-lfs
}:

python3.pkgs.buildPythonApplication rec {
  pname = "github-backup";
  version = "0.42.0";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-tFfS3Z7xrbN2QEOrYcUVd8/YwGKfmR2NaUBeXuSL+tY=";
  };

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ git git-lfs ])
  ];

  # has no unit tests
  doCheck = false;

  meta = with lib; {
    description = "Backup a github user or organization";
    homepage = "https://github.com/josegonzalez/python-github-backup";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
