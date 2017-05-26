{ stdenv, fetchurl, patchelf }:

stdenv.mkDerivation rec {
  name    = "ssdeep-${version}";
  version = "2.13";

  src = fetchurl {
    url    = "mirror://sourceforge/ssdeep/${name}.tar.gz";
    sha256 = "1igqy0j7jrklb8fdlrm6ald4cyl1fda5ipfl8crzyl6bax2ajk3f";
  };

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" '';

  # For some reason (probably a build system bug), the binary isn't
  # properly linked to $out/lib to find libfuzzy.so
  postFixup = stdenv.lib.optionalString (!stdenv.isDarwin) ''
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
