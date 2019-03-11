{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "twitter";
  version = "1.18.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "acdc85e5beea752967bb64c63bde8b915c49a31a01db1b2fecccf9f2c1d5c44d";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Twitter API library";
    license     = licenses.mit;
    maintainers = with maintainers; [ thoughtpolice ];
  };

}
