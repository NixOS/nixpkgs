{stdenv, fetchurl, perl, XMLSimple}:

stdenv.mkDerivation {
  name = "icon-naming-utils-0.8.7";
  src = fetchurl {
    url = http://tango.freedesktop.org/releases/icon-naming-utils-0.8.7.tar.gz;
    sha256 = "1lj0lffdg7fjfinhrn0vsq1kj010dxlxlix4jfc969j6l3k9rd0w";
  };
  buildInputs = [perl XMLSimple];
  postInstall = "
    # Add XML::Simple to the runtime search path.
    substituteInPlace $out/libexec/icon-name-mapping \\
        --replace '/bin/perl' '/bin/perl -I${XMLSimple}/lib/site_perl';
    ensureDir $out/lib
    ln -s $out/share/pkgconfig $out/lib/pkgconfig # WTF?
  ";
}
