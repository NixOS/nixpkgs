<<<<<<< HEAD
{ lib
, fetchFromGitHub
, fetchpatch
, python3Packages
, help2man
, installShellFiles
}:

python3Packages.buildPythonApplication rec {
  pname = "crudini";
  version = "0.9.4";
  format = "pyproject";
=======
{ lib, fetchFromGitHub, python3Packages, help2man, installShellFiles }:

python3Packages.buildPythonApplication rec {
  pname = "crudini";
  version = "0.9.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pixelb";
    repo = "crudini";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-jbTOaCF/ZqRpM0scDBBAcV5bSYg/QhBPbM9R5cONZ2o=";
  };

  patches = [
    (fetchpatch {
      name = "add-missing-install-file.patch";
      url = "https://github.com/pixelb/crudini/commit/d433e4d9c4106ae26985e3f4b2efa593bdd5c274.patch";
      hash = "sha256-aDGzoG4i2tvYeL8m1WoqwNFNHe4xR1dGk+XDt3f3i5E=";
    })
  ];

  postPatch = ''
    patchShebangs crudini.py crudini-help tests/test.sh
  '';

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    help2man
    installShellFiles
    python3Packages.setuptools
    python3Packages.setuptools-scm
    python3Packages.wheel
  ];

  propagatedBuildInputs = with python3Packages; [ iniparse ];

=======
    sha256 = "0298hvg0fpk0m0bjpwryj3icksbckwqqsr9w1ain55wf5s0v24k3";
  };

  nativeBuildInputs = [ help2man installShellFiles ];

  propagatedBuildInputs = with python3Packages; [ iniparse ];

  postPatch = ''
    substituteInPlace crudini-help \
      --replace ./crudini $out/bin/crudini
    substituteInPlace tests/test.sh \
      --replace ..: $out/bin:
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postInstall = ''
    # this just creates the man page
    make all

<<<<<<< HEAD
    install -Dm444 -t $out/share/doc/${pname} README.md EXAMPLES
=======
    install -Dm444 -t $out/share/doc/${pname} README EXAMPLES
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    installManPage *.1
  '';

  checkPhase = ''
    runHook preCheck

    pushd tests >/dev/null
<<<<<<< HEAD
    ./test.sh
=======
    bash ./test.sh
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    popd >/dev/null

    runHook postCheck
  '';

  meta = with lib; {
    description = "A utility for manipulating ini files ";
    homepage = "https://www.pixelbeat.org/programs/crudini/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ peterhoeg ];
<<<<<<< HEAD
    mainProgram = "crudini";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
