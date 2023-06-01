{ lib, stdenv, fetchFromGitHub, fuse }:

stdenv.mkDerivation {
  pname = "9pfs";
  version = "unstable-2015-09-18";

  src = fetchFromGitHub {
    owner = "mischief";
    repo = "9pfs";
    rev = "7f4ca4cd750d650c1215b92ac3cc2a28041960e4";
    sha256 = "007s2idsn6bspmfxv1qabj39ggkgvn6gwdbhczwn04lb4c6gh3xc";
  };

  # Upstream development has stopped and is no longer accepting patches
  # https://github.com/mischief/9pfs/pull/3
  patches = [ ./fix-darwin-build.patch ];

  preConfigure =
    ''
      substituteInPlace Makefile --replace '-g bin' ""
      installFlagsArray+=(BIN=$out/bin MAN=$out/share/man/man1)
      mkdir -p $out/bin $out/share/man/man1
    '';

  buildInputs = [ fuse ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: lib/auth_rpc.o:/build/source/lib/../9pfs.h:35: multiple definition of
  #     `logfile'; 9pfs.o:/build/source/9pfs.h:35: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/mischief/9pfs";
    description = "FUSE-based client of the 9P network filesystem protocol";
    maintainers = [ lib.maintainers.eelco ];
    platforms = lib.platforms.unix;
    license = with lib.licenses; [ lpl-102 bsd2 ];
  };
}
