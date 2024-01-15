{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, e2fsprogs
, fuse
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fuse-ext2";
  version = "unstable-2020-07-12";

  src = fetchFromGitHub {
    owner = "alperakcan";
    repo = "fuse-ext2";
    rev = "899f17c982dadcea13aa447c3a83c53b9431435a";
    sha256 = "AE7Z+HePAy/h2TCNI9tsz6GVLdnE2AIOM3GnQzerKn8=";
  };

  patches = [
    # Remove references to paths outside the nix store
    ./remove-impure-paths.patch
    # Don't build macOS desktop installer
    ./darwin-no-installer.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    e2fsprogs
    fuse
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=incompatible-function-pointer-types";

  meta = with lib; {
    description = "FUSE module to mount ext2, ext3 and ext4 with read write support";
    homepage = "https://github.com/alperakcan/fuse-ext2";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.unix;
    mainProgram = "fuse-ext2";
  };
})
