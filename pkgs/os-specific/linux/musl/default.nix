{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name    = "musl-${version}";
  version = "1.1.18";

  src = fetchurl {
    url    = "http://www.musl-libc.org/releases/${name}.tar.gz";
    sha256 = "0651lnj5spckqjf83nz116s8qhhydgqdy3rkl4icbh5f05fyw5yh";
  };

  enableParallelBuilding = true;

  # Disable auto-adding stack protector flags,
  # so musl can selectively disable as needed
  hardeningDisable = [ "stackprotector" ];

  preConfigure = ''
    configureFlagsArray+=("--syslibdir=$out/lib")
  '';

  configureFlags = [
    "--enable-shared"
    "--enable-static"
    "CFLAGS=-fstack-protector-strong"
    # Fix cycle between outputs
    "--disable-wrapper"
  ];

  outputs = [ "out" "dev" ];

  dontDisableStatic = true;

  meta = {
    description = "An efficient, small, quality libc implementation";
    homepage    = "http://www.musl-libc.org";
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
