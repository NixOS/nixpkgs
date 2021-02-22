{lib, stdenv, fetchurl, perlPackages, librsvg}:

stdenv.mkDerivation rec {
  name = "icon-naming-utils-0.8.90";

  src = fetchurl {
    url = "http://tango.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "071fj2jm5kydlz02ic5sylhmw6h2p3cgrm3gwdfabinqkqcv4jh4";
  };

  buildInputs = [ librsvg ] ++ (with perlPackages; [ perl XMLSimple ]);

  postInstall =
    ''
      # Add XML::Simple to the runtime search path.
      substituteInPlace $out/libexec/icon-name-mapping \
          --replace '/bin/perl' '/bin/perl -I${perlPackages.XMLSimple}/${perlPackages.perl.libPrefix}'
    '';

  meta = with lib; {
    homepage = "http://tango.freedesktop.org/Standard_Icon_Naming_Specification";
    platforms = with platforms; linux ++ darwin;
    license = licenses.gpl2;
  };
}
