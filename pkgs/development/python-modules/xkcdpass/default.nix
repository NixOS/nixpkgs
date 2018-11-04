{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "xkcdpass";
  version = "1.16.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "62961d24466964f4770bdbdbcca9ebdb148d0bdb48a8329c7bf41e9317dbb9d4";
  };

  # No tests included
  # https://github.com/redacted/XKCD-password-generator/issues/32
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://pypi.python.org/pypi/xkcdpass/;
    description = "Generate secure multiword passwords/passphrases, inspired by XKCD";
    license = licenses.bsd3;
  };

}
