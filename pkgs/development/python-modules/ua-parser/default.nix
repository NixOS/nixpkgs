{ stdenv, buildPythonPackage, fetchPypi, pyyaml }:

buildPythonPackage rec {
  pname = "ua-parser";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qpw1jdm8bp09jwjp8r38rr7rd2jy4k2if798cax3wylphm285xy";
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
