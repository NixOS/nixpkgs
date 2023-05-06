{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, numpy
, scipy
, six
, pandas
, pyyaml
, matplotlib
, numba
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "trackpy";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "soft-matter";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-NG1TOppqRbIZHLxJjlaXD4icYlAUkSxtmmC/fsS/pXo=";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    six
    pandas
    pyyaml
    matplotlib
    numba
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

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "Particle-tracking toolkit";
    homepage = "https://github.com/soft-matter/trackpy";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
