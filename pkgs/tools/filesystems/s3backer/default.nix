{ lib, stdenv, fetchFromGitHub
, autoreconfHook, pkg-config
, fuse, curl, expat }:

stdenv.mkDerivation rec {
  pname = "s3backer";
  version = "1.6.1";

  src = fetchFromGitHub {
    sha256 = "sha256-67sVT72i8tOMdGH/+Oh1N7Vh/2/qD56ImGWI+tprMOM=";
    rev = version;
    repo = "s3backer";
    owner = "archiecobbs";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ fuse curl expat ];

  # AC_CHECK_DECLS doesn't work with clang
  postPatch = lib.optionalString stdenv.cc.isClang ''
    substituteInPlace configure.ac --replace \
      'AC_CHECK_DECLS(fdatasync)' ""
  '';

  autoreconfPhase = ''
    patchShebangs ./autogen.sh
    ./autogen.sh
  '';

  meta = with lib; {
    homepage = "https://github.com/archiecobbs/s3backer";
    description = "FUSE-based single file backing store via Amazon S3";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
