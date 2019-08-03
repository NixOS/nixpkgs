{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sorl-thumbnail";
  version = "12.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8dfe5fda91a5047d1d35a0b9effe7b000764a01d648e15ca076f44e9c34b6dbd";
  };

  # Disabled due to an improper configuration error when tested against django. This looks like something broken in the test cases for sorl.
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://sorl-thumbnail.readthedocs.org/en/latest/;
    description = "Thumbnails for Django";
    license = licenses.bsd3;
  };

}
