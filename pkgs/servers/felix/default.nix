{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "apache-felix";
  version = "7.0.1";
  src = fetchurl {
    url = "mirror://apache/felix/org.apache.felix.main.distribution-${version}.tar.gz";
    sha256 = "sha256-WypiOdJhqKngIFVNf/XXAUDRdS8rANxWrcT846hcWTo=";
  };
  buildCommand =
  ''
    tar xfvz $src
    cd felix-framework-*
    mkdir -p $out
    cp -av * $out
  '';
  meta = with lib; {
    description = "An OSGi gateway";
    homepage = "https://felix.apache.org";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = [ maintainers.sander ];
  };
}
