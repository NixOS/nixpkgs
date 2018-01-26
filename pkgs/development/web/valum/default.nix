{ stdenv, meson, ninja, pkgconfig, fetchFromGitHub, glib, vala, ctpl
, libgee, libsoup, fcgi }:

stdenv.mkDerivation rec {
  name = "valum-${version}";
  version = "0.3.14";

  src = fetchFromGitHub {
    owner = "valum-framework";
    repo = "valum";
    rev = "v${version}";
    sha256 = "1w1mipczcfmrrxg369wvrj3wvf76rqn8rrkxbq88aial1bi23kd3";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [ glib vala ctpl libgee libsoup fcgi ];

  meta = with stdenv.lib; {
    homepage = https://github.com/valum-framework/valum;
    description = "Web micro-framework written in Vala";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };
}
