{ lib
<<<<<<< HEAD
, python3
, fetchPypi
, nix-update-script
=======
, nix-update-script
, python3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

python3.pkgs.buildPythonApplication rec {
  pname = "synadm";
<<<<<<< HEAD
  version = "0.42";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nfKXg4q+fOH0IwenEQ7P5x+YgwaooWpjn0gWHxK6tcc=";
=======
  version = "0.41.2";
  format = "setuptools";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-wSpgc1umBMLCc2ThfYSuNNnzqWXyEQM0XhTuOAQaiXg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = with python3.pkgs; [
    click
    click-option-group
    dnspython
    tabulate
    pyyaml
    requests
  ];

  checkPhase = ''
    runHook preCheck
    export HOME=$TMPDIR
    $out/bin/synadm -h > /dev/null
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Command line admin tool for Synapse";
    longDescription = ''
      A CLI tool to help admins of Matrix Synapse homeservers
      conveniently issue commands available via its admin API's
      (matrix-org/synapse@master/docs/admin_api)
    '';
    changelog = "https://github.com/JOJ0/synadm/releases/tag/v${version}";
    homepage = "https://github.com/JOJ0/synadm";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hexa ];
  };
}
