{ lib
, fetchPypi
, buildPythonPackage
, guessit
, babelfish
, enzyme
, beautifulsoup4
, requests
, click
, dogpile-cache
, stevedore
, chardet
, pysrt
, six
, appdirs
, rarfile
, pytz
, sympy
, vcrpy
, pytest
, pytest-flakes
, pytest-cov
, pytest-runner
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
    click dogpile-cache stevedore chardet pysrt six
    appdirs rarfile pytz
  ];

  nativeCheckInputs = [
    sympy vcrpy pytest pytest-flakes
    pytest-cov pytest-runner
  ];

  # https://github.com/Diaoul/subliminal/pull/963
  doCheck = false;
  pythonImportsCheck = [ "subliminal" ];

  meta = with lib; {
    homepage = "https://github.com/Diaoul/subliminal";
    description = "Python library to search and download subtitles";
    license = licenses.mit;
  };
}
