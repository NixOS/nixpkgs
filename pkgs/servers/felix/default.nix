{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "apache-felix-2.0.5";
  src = fetchurl {
    url = http://apache.xl-mirror.nl/felix/org.apache.felix.main.distribution-2.0.5.tar.gz;
    sha256 = "14nva0q1b45kmmalcls5yx97syd4vn3vcp8gywck1098qhidi66g";
  };
  buildCommand =
  ''
    tar xfvz $src
    cd felix-framework-*
    mkdir -p $out
    cp -av * $out
  '';
  meta = {
    description = "Apache Felix OSGi gateway";
    homepage = http://felix.apache.org;
    license = "ASF";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
