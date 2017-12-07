{ stdenv, fetchFromGitHub
, autoreconfHook, pkgconfig
, fuse, curl, expat }:

stdenv.mkDerivation rec {
  name = "s3backer-${version}";
  version = "1.4.3";

  src = fetchFromGitHub {
    sha256 = "0fhkha5kap8dji3iy48cbszhq83b2anssscgjj9d5dsl5dj57zak";
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
    maintainers = with maintainers; [ nckx ];
    platforms = with platforms; linux;
  };
}
