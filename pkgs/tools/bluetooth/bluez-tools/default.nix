{ lib, stdenv, autoreconfHook, readline
, fetchFromGitHub, glib, pkg-config }:

stdenv.mkDerivation rec {
  version = "unstable-2016-12-12";
  pname = "bluez-tools";

  src = fetchFromGitHub {
    owner = "khvzak";
    repo = "bluez-tools";
    rev = "97efd293491ad7ec96a655665339908f2478b3d1";
    sha256 = "08xp77sf5wnq5086halmyk3vla4bfls06q1zrqdcq36hw6d409i6";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  buildInputs = [ readline glib ];

  meta = with lib; {
    description = "Command line bluetooth manager for Bluez5";
    license = licenses.gpl2;
    maintainers = [ maintainers.dasuxullebt ];
    platforms = platforms.unix;
  };

}
