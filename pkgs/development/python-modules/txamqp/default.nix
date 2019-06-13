{ stdenv
, buildPythonPackage
, fetchurl
, twisted
}:

buildPythonPackage rec {
  pname = "txamqp";
  version = "0.3";

  src = fetchurl {
    url = "https://launchpad.net/txamqp/trunk/${version}/+download/python-txamqp_${version}.orig.tar.gz";
    sha256 = "1r2ha0r7g14i4b5figv2spizjrmgfpspdbl1m031lw9px2hhm463";
  };

  buildInputs = [ twisted ];

  meta = with stdenv.lib; {
    homepage = https://launchpad.net/txamqp;
    description = "Library for communicating with AMQP peers and brokers using Twisted";
    license = licenses.asl20;
    maintainers = with maintainers; [ rickynils ];
  };

}
