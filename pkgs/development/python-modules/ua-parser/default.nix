{ stdenv, buildPythonPackage, fetchPypi, pyyaml }:

buildPythonPackage rec {
  pname = "ua-parser";
  version = "0.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p8siba0rnb5nsl354fd5fc4751d5ybw7hgnd56yn8dncxdb1bqa";
  };

  buildInputs = [ pyyaml ];

  doCheck = false; # requires files from uap-core

  meta = with stdenv.lib; {
    description = "A python implementation of the UA Parser";
    homepage = https://github.com/ua-parser/uap-python;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda ];
  };
}
