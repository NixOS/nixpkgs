{ stdenv, buildPythonPackage, fetchPypi, pyyaml }:

buildPythonPackage rec {
  pname = "ua-parser";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "97bbcfc9321a3151d96bb5d62e54270247b0e3be0590a6f2ff12329851718dcb";
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
