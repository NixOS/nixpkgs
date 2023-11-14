{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, looseversion
, matplotlib
, numba
, numpy
, pandas
, pytestCheckHook
, pythonOlder
, pyyaml
, scipy
, setuptools
}:

buildPythonPackage rec {
  pname = "trackpy";
  version = "0.6.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "soft-matter";
    repo = "trackpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-NG1TOppqRbIZHLxJjlaXD4icYlAUkSxtmmC/fsS/pXo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    looseversion
    matplotlib
    numba
    numpy
    pandas
    pyyaml
    scipy
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

  pythonImportsCheck = [
    "trackpy"
  ];

  disabledTests = [
    # AttributeError, IndexError
    "TestLocateBrightfieldRing"
    "test_drop_link"
    "TestMSD"
    "test_correlation3D_ring"
  ];

  meta = with lib; {
    description = "Particle-tracking toolkit";
    homepage = "https://github.com/soft-matter/trackpy";
    changelog = "https://github.com/soft-matter/trackpy/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    broken = (stdenv.isLinux && stdenv.isAarch64);
  };
}
