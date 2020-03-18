{ stdenv
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
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "soft-matter";
    repo = pname;
    rev = "v${version}";
    sha256 = "16mc22z3104fvygky4gy3gvifjijm42db48v2z1y0fmyf6whi9p6";
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
    ${stdenv.lib.optionalString (stdenv.isDarwin) ''
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

  meta = with stdenv.lib; {
    description = "Particle-tracking toolkit";
    homepage = https://github.com/soft-matter/trackpy;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
    broken = true; # not compatible with latest pandas
  };
}
