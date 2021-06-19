{ lib, stdenv
, buildPythonPackage
, fetchFromGitHub
, numpy
, scipy
, six
, pandas
, pyyaml
, matplotlib
, pytest
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
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    ${lib.optionalString (stdenv.isDarwin) ''
    # specifically needed for darwin
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.matplotlib
    echo "backend: ps" > $HOME/.matplotlib/matplotlibrc
    ''}

    pytest trackpy --ignore trackpy/tests/test_motion.py \
                   --ignore trackpy/tests/test_feature_saving.py \
                   --ignore trackpy/tests/test_feature.py \
                   --ignore trackpy/tests/test_plots.py \
                   --ignore trackpy/tests/test_legacy_linking.py
  '';

  meta = with lib; {
    description = "Particle-tracking toolkit";
    homepage = "https://github.com/soft-matter/trackpy";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
    broken = true; # not compatible with latest pandas
  };
}
