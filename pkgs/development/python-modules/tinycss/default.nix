{ pkgs
, buildPythonPackage
, fetchPypi
, pytest
, python
, cssutils
, isPyPy
}:

buildPythonPackage rec {
  pname = "tinycss";
  version = "0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12306fb50e5e9e7eaeef84b802ed877488ba80e35c672867f548c0924a76716e";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ cssutils ];

  checkPhase = ''
    py.test $out/${python.sitePackages}
  '';

  # Disable Cython tests for PyPy
  TINYCSS_SKIP_SPEEDUPS_TESTS = pkgs.lib.optional isPyPy true;

  meta = with pkgs.lib; {
    description = "Complete yet simple CSS parser for Python";
    license = licenses.bsd3;
    homepage = https://pythonhosted.org/tinycss/;
    maintainers = [ maintainers.costrouc ];
  };
}
