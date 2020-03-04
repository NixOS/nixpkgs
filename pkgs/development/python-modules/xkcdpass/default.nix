{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "xkcdpass";
  version = "1.17.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "95cf3fd41130606ba64ec7edb9efac7c5d61efe21abab51a2c21ccbbebc48bb6";
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
