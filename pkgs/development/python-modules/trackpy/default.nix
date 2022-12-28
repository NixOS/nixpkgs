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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "soft-matter";
    repo = pname;
    rev = "v${version}";
    sha256 = "0if069f4sjyjl7wvzyzk8k9q9qjixswcc6aszrrgfb4a4mix3h1g";
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

  checkInputs = [
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
