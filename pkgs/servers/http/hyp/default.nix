{ stdenv, fetchurl, python3Packages }:

python3Packages.buildPythonPackage rec {
  name = "hyp-server-${version}";
  version = "1.2.0";

  src = fetchurl {
    url    = "mirror://pypi/h/hyp-server/${name}.tar.gz";
    sha256 = "1lafjdcn9nnq6xc3hhyizfwh6l69lc7rixn6dx65aq71c913jc15";
  };

  meta = with stdenv.lib; {
    description = "Hyperminimal https server";
    homepage    = https://github.com/rnhmjoj/hyp;
    license     = with licenses; [gpl3Plus mit];
    maintainers = with maintainers; [ rnhmjoj ];
    platforms   = platforms.unix;
  };
}
