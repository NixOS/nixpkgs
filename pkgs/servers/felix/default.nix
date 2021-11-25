{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "apache-felix";
  version = "7.0.0";
  src = fetchurl {
    url = "mirror://apache/felix/org.apache.felix.main.distribution-${version}.tar.gz";
    sha256 = "sha256-ea1QYUqf6m3HB17TrEQ7UEc48fl5QHQMYsN3t0T9VD4=";
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
    license = licenses.asl20;
    maintainers = [ maintainers.sander ];
  };
}
