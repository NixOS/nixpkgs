{ stdenv, fetchurl, llvmPackages }:

stdenv.mkDerivation rec {
  name    = "musl-${version}";
  version = "1.1.14";

  src = fetchurl {
    url    = "http://www.musl-libc.org/releases/${name}.tar.gz";
    sha256 = "1ddral87srzk741cqbfrx9aygnh8fpgfv7mjvbain2d6hh6c1xim";
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

  dontDisableStatic = true;

  # needed for rustc musl build
  postInstall = "cp ${llvmPackages.libunwind}/lib/libunwind.a $out/lib/";

  meta = {
    description = "An efficient, small, quality libc implementation";
    homepage    = "http://www.musl-libc.org";
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
