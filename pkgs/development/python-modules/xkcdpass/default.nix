{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "xkcdpass";
  version = "1.17.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ghsjs5bxl996pap910q9s21nywb26mfpjd92rbfywbnj8f2k2cy";
  };

  # No tests included
  # https://github.com/redacted/XKCD-password-generator/issues/32
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://pypi.python.org/pypi/xkcdpass/";
    description = "Generate secure multiword passwords/passphrases, inspired by XKCD";
    license = licenses.bsd3;
  };

}
