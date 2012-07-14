{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "haproxy-1.4.20";
  
  src = fetchurl {
    url = http://haproxy.1wt.eu/download/1.4/src/haproxy-1.4.20.tar.gz;
    sha256 = "0gi81dg8k3ypljs7ifbppvpfrwrnbafjv41fjpwnyqfwbxa4j2gh";
  };

  buildInputs = [];

  preConfigure = ''
    export makeFlags="TARGET=linux26 PREFIX=$out"
  '';
  
  meta = {
    description = "HAProxy is a free, very fast and reliable solution offering high availability, load balancing, and proxying for TCP and HTTP-based applications.";
    homepage = http://haproxy.1wt.eu/;
  };
}
