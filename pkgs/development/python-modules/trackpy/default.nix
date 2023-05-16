{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, looseversion
, matplotlib
, numba
, numpy
, pandas
, pytestCheckHook
, pythonOlder
, pyyaml
, scipy
=======
, numpy
, scipy
, six
, pandas
, pyyaml
, matplotlib
, numba
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "trackpy";
  version = "0.6.1";
<<<<<<< HEAD
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "soft-matter";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-NG1TOppqRbIZHLxJjlaXD4icYlAUkSxtmmC/fsS/pXo=";
  };

  propagatedBuildInputs = [
<<<<<<< HEAD
    looseversion
    matplotlib
    numba
    numpy
    pandas
    pyyaml
    scipy
=======
    numpy
    scipy
    six
    pandas
    pyyaml
    matplotlib
    numba
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = lib.optionalString stdenv.isDarwin ''
    # specifically needed for darwin
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.matplotlib
    echo "backend: ps" > $HOME/.matplotlib/matplotlibrc
  '';

<<<<<<< HEAD
  pythonImportsCheck = [
    "trackpy"
  ];

  meta = with lib; {
    description = "Particle-tracking toolkit";
    homepage = "https://github.com/soft-matter/trackpy";
    changelog = "https://github.com/soft-matter/trackpy/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    broken = (stdenv.isLinux && stdenv.isAarch64);
=======
  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "Particle-tracking toolkit";
    homepage = "https://github.com/soft-matter/trackpy";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
