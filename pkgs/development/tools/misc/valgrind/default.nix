{stdenv, fetchurl, perl}:

# Note: I added the Perl dependency for Valgrind 2.1.1.  It's needed
# to generate some files.  Maybe in stable releases we won't need
# Perl.
# Update: 2.2.0 still needs it.

stdenv.mkDerivation {
  name = "valgrind-2.2.0";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/valgrind-2.2.0.tar.bz2;
    md5 = "30dc51f6fc94751b90b04af9c2e2c656";
  };
  buildInputs = [perl];

  # Hack to get Valgrind to compile with Linux 2.6.10 headers.  The
  # file `include/asm/processor.h' indirectly needs
  # CONFIG_X86_L1_CACHE_SHIFT (for the alignment of some type that
  # probably isn't relevant here anyway).
  # !!! maybe this should be done in linux-headers?
  NIX_CFLAGS_COMPILE = "-DCONFIG_X86_L1_CACHE_SHIFT=7";

  # Another kernel header problem.
  patches = [./pgoff_t.patch];
}
