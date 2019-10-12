{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "apache-felix";
  version = "5.6.1";
  src = fetchurl {
    url = "mirror://apache/felix/org.apache.felix.main.distribution-${version}.tar.gz";
    sha256 = "0kis26iajzdid162j4i7g558q09x4hn9z7pqqys6ipb0fj84hz1x";
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
    homepage = https://felix.apache.org;
    license = licenses.asl20;
    maintainers = [ maintainers.sander ];
  };
}
