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
}:

buildPythonPackage rec {
  pname = "trackpy";
  version = "0.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "soft-matter";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-NG1TOppqRbIZHLxJjlaXD4icYlAUkSxtmmC/fsS/pXo=";
  };

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

  meta = with lib; {
    description = "Particle-tracking toolkit";
    homepage = "https://github.com/soft-matter/trackpy";
    changelog = "https://github.com/soft-matter/trackpy/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    broken = (stdenv.isLinux && stdenv.isAarch64);
  };
}
