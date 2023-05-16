{ lib
, python3
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, git
, git-lfs
}:

python3.pkgs.buildPythonApplication rec {
  pname = "github-backup";
<<<<<<< HEAD
  version = "0.43.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-S0674oTUsXftXlbP8fbF09FIWnWwq/Mgbv960tg3FNg=";
=======
  version = "0.42.0";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-tFfS3Z7xrbN2QEOrYcUVd8/YwGKfmR2NaUBeXuSL+tY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  makeWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ git git-lfs ])
  ];

  # has no unit tests
  doCheck = false;

  meta = with lib; {
    description = "Backup a github user or organization";
    homepage = "https://github.com/josegonzalez/python-github-backup";
<<<<<<< HEAD
    changelog = "https://github.com/josegonzalez/python-github-backup/blob/${version}/CHANGES.rst";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
