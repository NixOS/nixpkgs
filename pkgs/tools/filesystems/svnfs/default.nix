{ lib, stdenv, fetchurl, autoreconfHook, subversion, fuse, apr, perl }:

stdenv.mkDerivation rec {
  pname = "svnfs";
  version = "0.4";

  src = fetchurl {
    url = "http://www.jmadden.eu/wp-content/uploads/svnfs/svnfs-${version}.tgz";
    sha256 = "1lrzjr0812lrnkkwk60bws9k1hq2iibphm0nhqyv26axdsygkfky";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ subversion fuse apr perl ];

  # autoconf's AC_CHECK_HEADERS and AC_CHECK_LIBS fail to detect libfuse on
  # Darwin if FUSE_USE_VERSION isn't set at configure time.
  #
  # NOTE: Make sure the value of FUSE_USE_VERSION specified here matches the
  # actual version used in the source code:
  #
  #     $ tar xf "$(nix-build -A svnfs.src)"
  #     $ grep -R FUSE_USE_VERSION
  configureFlags = lib.optionals stdenv.isDarwin [ "CFLAGS=-DFUSE_USE_VERSION=25" ];

  # why is this required?
  preConfigure=''
    export LD_LIBRARY_PATH=${subversion.out}/lib
  '';

  # -fcommon: workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: svnclient.o:/build/svnfs-0.4/src/svnfs.h:40: multiple definition of
  #     `dirbuf'; svnfs.o:/build/svnfs-0.4/src/svnfs.h:40: first defined here
  NIX_CFLAGS_COMPILE="-I ${subversion.dev}/include/subversion-1 -fcommon";
  NIX_LDFLAGS="-lsvn_client-1 -lsvn_subr-1";

  meta = {
    description = "FUSE filesystem for accessing Subversion repositories";
    homepage = "http://www.jmadden.eu/index.php/svnfs/";
    license = lib.licenses.gpl2Only;
    maintainers = [lib.maintainers.marcweber];
    platforms = lib.platforms.unix;
  };
}
