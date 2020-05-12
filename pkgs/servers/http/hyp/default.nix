{ stdenv, fetchurl, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "hyp-server";
  version = "1.2.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1lafjdcn9nnq6xc3hhyizfwh6l69lc7rixn6dx65aq71c913jc15";
  };

  meta = with stdenv.lib; {
    description = "Hyperminimal https server";
    homepage    = "https://github.com/rnhmjoj/hyp";
    license     = with licenses; [gpl3Plus mit];
    maintainers = with maintainers; [ rnhmjoj ];
    platforms   = platforms.unix;
  };
}
