{ stdenv, fetchFromGitHub
, autoreconfHook, pkgconfig
, fuse, curl, expat }:

stdenv.mkDerivation rec {
  name = "s3backer-${version}";
  version = "1.5.0";

  src = fetchFromGitHub {
    sha256 = "0pmszcnnlqyysljfyysd6jsvdz7fqgbk8z4vnkmda5dwwcm8b8fs";
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
