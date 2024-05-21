{ lib, stdenv, fetchFromGitHub
, autoreconfHook, pkg-config
, fuse, curl, expat }:

stdenv.mkDerivation rec {
  pname = "s3backer";
  version = "2.1.2";

  src = fetchFromGitHub {
    sha256 = "sha256-/WdY++rrcQ3N+4ROeaA113Iq1nMGxOp3LzsCaLsxaaM=";
    rev = version;
    repo = "s3backer";
    owner = "archiecobbs";
  };

  patches = [
    # from upstream, after latest release
    # https://github.com/archiecobbs/s3backer/commit/303a669356fa7cd6bc95ac7076ce51b1cab3970a
    ./fix-darwin-builds.patch
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ fuse curl expat ];

  # AC_CHECK_DECLS doesn't work with clang
  postPatch = lib.optionalString stdenv.cc.isClang ''
    substituteInPlace configure.ac --replace \
      'AC_CHECK_DECLS(fdatasync)' ""
  '';

  meta = with lib; {
    homepage = "https://github.com/archiecobbs/s3backer";
    description = "FUSE-based single file backing store via Amazon S3";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    mainProgram = "s3backer";
  };
}
