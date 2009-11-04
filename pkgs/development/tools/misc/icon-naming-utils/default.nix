{stdenv, fetchurl, perl, XMLSimple}:

stdenv.mkDerivation rec {
  name = "icon-naming-utils-0.8.90";

  src = fetchurl {
    url = "http://tango.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "071fj2jm5kydlz02ic5sylhmw6h2p3cgrm3gwdfabinqkqcv4jh4";
  };
  
  buildInputs = [perl XMLSimple];

  postInstall =
    ''
      # Add XML::Simple to the runtime search path.
      substituteInPlace $out/libexec/icon-name-mapping \
          --replace '/bin/perl' '/bin/perl -I${XMLSimple}/lib/perl5/site_perl'
    '';

  meta = {
    homepage = http://tango.freedesktop.org/Standard_Icon_Naming_Specification;
  };
}
