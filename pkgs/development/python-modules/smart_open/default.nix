{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, boto
, bz2file
, moto
, requests
, responses
}:

buildPythonPackage rec {
  pname = "smart_open";
  name = "${pname}-${version}";
  version = "1.5.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8fd2de1c359bd0074bd6d334a5b9820ae1c5b6ba563970b95052bace4b71baeb";
  };

  propagatedBuildInputs = [ boto bz2file requests responses moto ];
  meta = {
    license = lib.licenses.mit;
    description = "smart_open is a Python 2 & Python 3 library for efficient streaming of very large file";
    maintainers = with lib.maintainers; [ jyp ];
  };
}
