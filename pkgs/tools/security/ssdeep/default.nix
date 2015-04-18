{ stdenv, fetchurl, patchelf }:

stdenv.mkDerivation rec {
  name    = "ssdeep-${version}";
  version = "2.12";

  src = fetchurl {
    url    = "mirror://sourceforge/ssdeep/${name}.tar.gz";
    sha256 = "1pjb3qpcn6slfqjv23jf7i8zf7950b7h27b0v0dva5pxmn3rw149";
  };

  # For some reason (probably a build system bug), the binary isn't
  # properly linked to $out/lib to find libfuzzy.so
  postFixup = ''
    rp=$(patchelf --print-rpath $out/bin/ssdeep)
    patchelf --set-rpath $rp:$out/lib $out/bin/ssdeep
  '';

  meta = {
    description = "A program for calculating fuzzy hashes";
    homepage    = "http://www.ssdeep.sf.net";
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
