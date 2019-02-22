{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "xkcdpass";
  version = "1.17.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ae7ad57c0287cc41c8c9f164b59296463f2e009d4b7aed382160cb40dfb4d91b";
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
