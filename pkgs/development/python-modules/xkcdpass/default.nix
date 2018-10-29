{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "xkcdpass";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c1f8bee886820c42ccc64c15c3a2275dc6d01028cf6af7c481ded87267d8269";
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
