{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libstrangle";
  version = "2017-02-22";

  src = fetchFromGitHub {
    owner = "milaq";
    repo = pname;
    rev = "6020f9e375ba747c75eb7996b7d5f0214ac3221e";
    sha256 = "04ikacbjcq9phdc8q5y1qjjpa1sxmzfm0idln9ys95prg289zp4h";
  };

  makeFlags = [ "prefix=" "DESTDIR=$(out)" ];

  patches = [ ./nixos.patch ];

  postPatch = ''
    substituteAllInPlace src/strangle.sh
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/milaq/libstrangle";
    description = "Frame rate limiter for Linux/OpenGL";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ aske ];
  };
}
