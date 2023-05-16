{  buildPythonPackage
, stestr
}:

<<<<<<< HEAD
buildPythonPackage {
  pname = "stestr-tests";
  inherit (stestr) version src;
  format = "other";
=======
buildPythonPackage rec {
  pname = "stestr-tests";
  inherit (stestr) version;

  src = stestr.src;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  dontBuild = true;
  dontInstall = true;
  preConfigure = ''
    pythonOutputDistPhase() { touch $dist; }
  '';

  nativeCheckInputs = [
    stestr
  ];

  checkPhase = ''
    export PATH=$out/bin:$PATH
    export HOME=$TMPDIR
  '';
}
