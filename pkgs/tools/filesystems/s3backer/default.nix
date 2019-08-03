{ stdenv, fetchFromGitHub
, autoreconfHook, pkgconfig
, fuse, curl, expat }:

stdenv.mkDerivation rec {
  name = "s3backer-${version}";
  version = "1.5.2";

  src = fetchFromGitHub {
    sha256 = "1axxnhhf335xckwn43csqmvf1454izbk9dglc3r7isrk0lz1ricc";
    rev = version;
    repo = "s3backer";
    owner = "archiecobbs";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ fuse curl expat ];

  autoreconfPhase = ''
    patchShebangs ./autogen.sh
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/archiecobbs/s3backer;
    description = "FUSE-based single file backing store via Amazon S3";
    license = licenses.gpl2Plus;
    platforms = with platforms; linux;
  };
}
