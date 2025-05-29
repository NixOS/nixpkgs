{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.1.2";
  pname = "apache-felix-remoteshell-bundle";
  src = fetchurl {
    url = "http://apache.proserve.nl/felix/org.apache.felix.shell.remote-${version}.jar";
    sha256 = "147zw5ppn98wfl3pr32isyb267xm3gwsvdfdvjr33m9g2v1z69aq";
  };
  buildCommand = ''
    mkdir -p $out/bundle
    cp ${src} $out/bundle/org.apache.felix.shell.remote-${version}.jar
  '';
}
