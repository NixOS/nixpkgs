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
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12v2clnbic8320fjsvkg3xfxfa7x8inhjk61z00pzwx46g3rqhy6";
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
    homepage = "https://github.com/Diaoul/subliminal";
    description = "Python library to search and download subtitles";
    license = licenses.mit;
  };
}
