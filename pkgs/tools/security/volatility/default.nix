{ stdenv, fetchurl, python2Packages }:

python2Packages.buildPythonApplication rec {
  version = "2.6";
  name = "volatility-${version}";

  src = fetchurl {
    url = "https://downloads.volatilityfoundation.org/releases/${version}/${name}.zip";
    sha256 = "15cjrx31nnqa3bpjkv0x05j7f2sb7pq46a72zh7qg55zf86hawsv";
  };

  doCheck = false;

  propagatedBuildInputs = [ python2Packages.pycrypto python2Packages.distorm3 ];

  meta = with stdenv.lib; {
    homepage = https://www.volatilityfoundation.org/;
    description = "Advanced memory forensics framework";
    maintainers = with maintainers; [ bosu ];
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
