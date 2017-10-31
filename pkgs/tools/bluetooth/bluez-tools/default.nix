{ stdenv, autoreconfHook, readline
, fetchFromGitHub, glib, pkgconfig }:

stdenv.mkDerivation rec {
  date    = "2016-12-12";
  name    = "bluez-tools-${date}";
  rev     = "97efd29";

  src = fetchFromGitHub {
    inherit rev;
    owner = "khvzak";
    repo = "bluez-tools";
    sha256 = "08xp77sf5wnq5086halmyk3vla4bfls06q1zrqdcq36hw6d409i6";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];

  buildInputs = [ readline glib ];

  meta = with stdenv.lib; {
    description = "Command line bluetooth manager for Bluez5";
    license = licenses.gpl2;
    maintainers = [ maintainers.dasuxullebt ];
    platforms = platforms.unix;
  };

}
