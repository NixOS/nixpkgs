{ lib
, fetchPypi
, buildPythonPackage
, isPy3k
, guessit
, babelfish
, enzyme
, beautifulsoup4
, requests
, click
, dogpile_cache
, stevedore
, chardet
, pysrt
, six
, appdirs
, rarfile
, pytz
, futures
, sympy
, vcrpy
, pytest
, pytestpep8
, pytest-flakes
, pytestcov
, pytestrunner
}:

buildPythonPackage rec {
  pname = "subliminal";
  version = "2.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dzv5csjcwgz69aimarx2c6606ckm2gbn4x2mzydcqnyai7sayhl";
  };

  propagatedBuildInputs = [
    guessit babelfish enzyme beautifulsoup4 requests
    click dogpile_cache stevedore chardet pysrt six
    appdirs rarfile pytz
  ] ++ lib.optional (!isPy3k) futures;

  checkInputs = [
    sympy vcrpy pytest pytestpep8 pytest-flakes
    pytestcov pytestrunner
  ];

  # https://github.com/Diaoul/subliminal/pull/963
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/Diaoul/subliminal;
    description = "Python library to search and download subtitles";
    license = licenses.mit;
  };
}
