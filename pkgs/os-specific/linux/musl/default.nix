{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name    = "musl-${version}";
  version = "1.1.16";

  src = fetchurl {
    url    = "http://www.musl-libc.org/releases/${name}.tar.gz";
    sha256 = "048h0w4yjyza4h05bkc6dpwg3hq6l03na46g0q1ha8fpwnjqawck";
  };

  enableParallelBuilding = true;

  # required to avoid busybox segfaulting on startup when invoking
  # nix-build "<nixpkgs/pkgs/stdenv/linux/make-bootstrap-tools.nix>"
  hardeningDisable = [ "stackprotector" ];

  preConfigure = ''
    configureFlagsArray+=("--syslibdir=$out/lib")
  '';

  configureFlags = [
    "--enable-shared"
    "--enable-static"
  ];

  patches = [];

  dontDisableStatic = true;

  meta = {
    description = "An efficient, small, quality libc implementation";
    homepage    = "http://www.musl-libc.org";
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
