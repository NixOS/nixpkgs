{ stdenv
, fetchurl
, buildPythonApplication
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
}:

buildPythonApplication rec {
  pname = "subliminal";
  name = "${pname}-${version}";
  version = "2.0.5";

  src = fetchurl {
    url = "mirror://pypi/s/subliminal/${name}.tar.gz";
    sha256 = "1dzv5csjcwgz69aimarx2c6606ckm2gbn4x2mzydcqnyai7sayhl";
  };

  # Too many test dependencies
  doCheck = false;
  propagatedBuildInputs = [ guessit babelfish enzyme beautifulsoup4 requests
                            click dogpile_cache stevedore chardet pysrt six
                            appdirs rarfile pytz futures ];

  meta = with stdenv.lib; {
    homepage = https://github.com/Diaoul/subliminal;
    description = "Python library to search and download subtitles";
    license = licenses.mit;
  };
}
