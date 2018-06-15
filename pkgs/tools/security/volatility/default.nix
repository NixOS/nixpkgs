{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  version = "2.6";
  name = "volatility-${version}";

  src = fetchurl {
    url = "http://downloads.volatilityfoundation.org/releases/${version}/${name}.zip";
    sha256 = "15cjrx31nnqa3bpjkv0x05j7f2sb7pq46a72zh7qg55zf86hawsv";
  };

  doCheck = false;

  propagatedBuildInputs = [ pythonPackages.pycrypto pythonPackages.distorm3 ];

  meta = with stdenv.lib; {
    homepage = http://www.volatilityfoundation.org/;
    description = "Advanced memory forensics framework";
    maintainers = with maintainers; [ bosu ];
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
