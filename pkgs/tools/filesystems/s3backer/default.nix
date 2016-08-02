{ stdenv, fetchFromGitHub
, autoreconfHook, pkgconfig
, fuse, curl, expat }:
  
stdenv.mkDerivation rec {
  name = "s3backer-${version}";
  version = "1.4.2";
  
  src = fetchFromGitHub {
    sha256 = "0b9vmykrfpzs9is31pqb8xvgjraghnax1ph2jkbib1ya0vhxm8dj";
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
    homepage = http://code.google.com/p/s3backer/;
    description = "FUSE-based single file backing store via Amazon S3";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ nckx ];
    platforms = with platforms; linux;
  };
}
