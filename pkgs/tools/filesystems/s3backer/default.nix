{ lib, stdenv, fetchFromGitHub
, autoreconfHook, pkg-config
, fuse, curl, expat }:

stdenv.mkDerivation rec {
  pname = "s3backer";
  version = "1.5.4";

  src = fetchFromGitHub {
    sha256 = "1228qlfgz48k9vv72hrz488zg73zls99cppb9vmikc0pzv1xndsx";
    rev = version;
    repo = "s3backer";
    owner = "archiecobbs";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ fuse curl expat ];

  autoreconfPhase = ''
    patchShebangs ./autogen.sh
    ./autogen.sh
  '';

  meta = with lib; {
    homepage = "https://github.com/archiecobbs/s3backer";
    description = "FUSE-based single file backing store via Amazon S3";
    license = licenses.gpl2Plus;
    platforms = with platforms; linux;
  };
}
