{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name    = "ssdeep-${version}";
  version = "2.10";

  src = fetchurl {
    url    = "mirror://sourceforge/ssdeep/${name}.tar.gz";
    sha256 = "1p7dgchq8hgadnxz5qh95ay17k5j74l4qyd15wspc54lb603p2av";
  };

  postFixup = ''
    patchelf --set-rpath "$(patchelf --print-rpath $out/bin/ssdeep):$out/lib" $out/bin/ssdeep
  '';

  meta = {
    description = "A program for calculating fuzzy hashes";
    homepage    = "http://www.ssdeep.sf.net";
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
