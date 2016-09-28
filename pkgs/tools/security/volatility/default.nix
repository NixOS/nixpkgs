{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "volatility-2.4";

  src = fetchurl {
    url = "http://downloads.volatilityfoundation.org/releases/2.4/${name}.tar.gz";
    sha256 = "1wffrkvj2lrkqhwamyix9fy05y6g6w8h1sz2iqlm6i6ag7yxykv8";
  };

  doCheck = false;

  propagatedBuildInputs = [ pythonPackages.pycrypto ];

  meta = with stdenv.lib; {
    homepage = https://code.google.com/p/volatility;
    description = "Advanced memory forensics framework";
    maintainers = with maintainers; [ bosu ];
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
