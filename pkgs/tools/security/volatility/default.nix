{ stdenv, fetchurl, buildPythonPackage, pycrypto }:

buildPythonPackage rec {
  namePrefix = "";
  name = "volatility-2.3.1";

  src = fetchurl {
    url = "http://volatility.googlecode.com/files/${name}.tar.gz";
    sha256 = "bb1411fc671e0bf550a31e534fb1991b2f940f1dce1ebe4ce2fb627aec40726c";
  };

  doCheck = false;

  propagatedBuildInputs = [ pycrypto ];

  meta = with stdenv.lib; {
    homepage = https://code.google.com/p/volatility;
    description = "advanced memory forensics framework";
    maintainers = with maintainers; [ bosu ];
    license = "GPLv2+";
  };
}
