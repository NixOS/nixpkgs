{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  fuse,
  git,
}:

stdenv.mkDerivation {
  pname = "aefs";
  version = "unstable-2015-05-06";

  src = fetchFromGitHub {
    owner = "edolstra";
    repo = "aefs";
    rev = "e7a9bf8cfa9166668fe1514cc1afd31fc4e10e9a";
    hash = "sha256-a3YQWxJ7+bYhf1W1kdIykV8U1R4dcDZJ7K3NvNxbF0s=";
  };

  # autoconf's AC_CHECK_HEADERS and AC_CHECK_LIBS fail to detect libfuse on
  # Darwin if FUSE_USE_VERSION isn't set at configure time.
  #
  # NOTE: Make sure the value of FUSE_USE_VERSION specified here matches the
  # actual version used in the source code:
  #
  #     $ tar xf "$(nix-build -A aefs.src)"
  #     $ grep -R FUSE_USE_VERSION
  configureFlags = lib.optional stdenv.isDarwin "CPPFLAGS=-DFUSE_USE_VERSION=26";

  nativeBuildInputs = [
    autoreconfHook
    git
  ];

  buildInputs = [ fuse ];

  meta = with lib; {
    homepage = "https://github.com/edolstra/aefs";
    description = "A cryptographic filesystem implemented in userspace using FUSE";
    maintainers = [ maintainers.eelco ];
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
}
