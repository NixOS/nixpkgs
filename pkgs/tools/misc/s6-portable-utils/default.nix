{ stdenv, fetchurl, skalibs, gcc }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "s6-portable-utils-${version}";
  version = "2.1.0.0";

  src = fetchurl {
    url = "http://www.skarnet.org/software/s6-portable-utils/${name}.tar.gz";
    sha256 = "0khw5ljmlghvl4hyrf4vd0hl5rrmsspchi8w4xgniwfip6vlbqfd";
  };

  dontDisableStatic = true;

  configureFlags = [
    "--enable-absolute-paths"
    "--with-sysdeps=${skalibs}/lib/skalibs/sysdeps"
    "--with-include=${skalibs}/include"
    "--with-lib=${skalibs}/lib"
    "--with-dynlib=${skalibs}/lib"
  ]
  # On darwin, the target triplet from -dumpmachine includes version number, but
  # skarnet.org software uses the triplet to test binary compatibility.
  # Explicitly setting target ensures code can be compiled against a skalibs
  # binary built on a different version of darwin.
  # http://www.skarnet.org/cgi-bin/archive.cgi?1:mss:623:heiodchokfjdkonfhdph
  ++ (stdenv.lib.optional stdenv.isDarwin "--build=${stdenv.system}");

  meta = {
    homepage = http://www.skarnet.org/software/s6-portable-utils/;
    description = "A set of tiny general Unix utilities optimized for simplicity and small size";
    platforms = platforms.all;
    license = licenses.isc;
    maintainers = with maintainers; [ pmahoney ];
  };

}
