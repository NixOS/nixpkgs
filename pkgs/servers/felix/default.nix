{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "apache-felix";
  version = "6.0.3";
  src = fetchurl {
    url = "mirror://apache/felix/org.apache.felix.main.distribution-${version}.tar.gz";
    sha256 = "1yk04q8rfbbabacbhmrsw5ywr96496x1cz4icdqimb1cfxixv1q0";
  };
  buildCommand =
  ''
    tar xfvz $src
    cd felix-framework-*
    mkdir -p $out
    cp -av * $out
  '';
  meta = with stdenv.lib; {
    description = "An OSGi gateway";
    homepage = "https://felix.apache.org";
    license = licenses.asl20;
    maintainers = [ maintainers.sander ];
  };
}
