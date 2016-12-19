{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  version = "1.1.2";
  name = "apache-felix-remoteshell-bundle-${version}";
  src = fetchurl {
    url = "http://apache.proserve.nl/felix/org.apache.felix.shell.remote-${version}.jar";
    sha256 = "147zw5ppn98wfl3pr32isyb267xm3gwsvdfdvjr33m9g2v1z69aq";
  };
  buildCommand =
  ''
    mkdir -p $out/bundle
    cp ${src} $out/bundle/org.apache.felix.shell.remote-${version}.jar
  '';
}
