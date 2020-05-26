{ stdenv, buildPythonPackage, fetchFromGitHub
, codecov, coverage
, flake8
, matplotlib
, mock
, numpy
, pillow
, pytest
, pytestcov
, pytest-sugar
, setuptools
, twine
, wheel
}:
  
buildPythonPackage rec {
  pname = "word_cloud";
  version = "1.6.0";

  # tests are not included in pypi tarball
  src = fetchFromGitHub {
    owner = "amueller";
    repo = pname;
    rev = version;
    sha256 = "1ncjr90m3w3b4zi23kw6ai11gxahdyah96x8jb2yn2x4573022x2";
  };

  propagatedBuildInputs = [ matplotlib numpy pillow ];

  # Tests require extra dependencies
  checkInputs = [ codecov coverage flake8 mock pytest pytestcov pytest-sugar setuptools twine wheel ];
  # skip tests which make assumptions about installation
  checkPhase = ''
    pytest -k 'not cli_as_executable'
  '';
  
  meta = with stdenv.lib; {
    description = "A little word cloud generator in Python";
    homepage = "https://github.com/amueller/word_cloud";
    license = licenses.mit;
    maintainers = with maintainers; [ jm2dev ];
  };
}
