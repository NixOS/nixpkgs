{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "apache-felix-remoteshell-bundle-1.0.4";
  src = fetchurl {
    url = http://apache.proserve.nl/felix/org.apache.felix.shell.remote-1.0.4.jar;
    sha256 = "1bgahzs9nnnvfr0yyh9s0r6h1zp2ls6533377rp8r1qk2a4s1gzb";
  };
  buildCommand = 
  ''
    ensureDir $out/bundle
    cp ${src} $out/bundle/org.apache.felix.shell.remote-1.0.4.jar
  '';
}
