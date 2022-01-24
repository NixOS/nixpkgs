{ lib, stdenv, fetchurl, fetchpatch, fuse }:

stdenv.mkDerivation rec {
  pname = "aefs";
  version = "0.4pre259-8843b7c";

  src = fetchurl {
    url = "http://tarballs.nixos.org/aefs-${version}.tar.bz2";
    sha256 = "167hp58hmgdavg2mqn5dx1xgq24v08n8d6psf33jhbdabzx6a6zq";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/edolstra/aefs/commit/15d8df8b8d5dc1ee20d27a86c4d23163a67f3123.patch";
      sha256 = "0k36hsyvf8a0ji2hpghgqff2fncj0pllxn8p0rs0aj4h7j2vp4iv";
    })
  ];

  # autoconf's AC_CHECK_HEADERS and AC_CHECK_LIBS fail to detect libfuse on
  # Darwin if FUSE_USE_VERSION isn't set at configure time.
  #
  # NOTE: Make sure the value of FUSE_USE_VERSION specified here matches the
  # actual version used in the source code:
  #
  #     $ tar xf "$(nix-build -A aefs.src)"
  #     $ grep -R FUSE_USE_VERSION
  configureFlags = lib.optional stdenv.isDarwin "CPPFLAGS=-DFUSE_USE_VERSION=26";

  buildInputs = [ fuse ];

  meta = with lib; {
    homepage = "https://github.com/edolstra/aefs";
    description = "A cryptographic filesystem implemented in userspace using FUSE";
    platforms = platforms.unix;
    maintainers = [ maintainers.eelco ];
    license = licenses.gpl2;
  };
}
