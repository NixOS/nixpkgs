{ stdenv, meson, ninja, pkgconfig, fetchFromGitHub, glib, vala, ctpl
, libgee, libsoup, fcgi }:

stdenv.mkDerivation rec {
  pname = "valum";
  version = "0.3.15";

  src = fetchFromGitHub {
    owner = "valum-framework";
    repo = "valum";
    rev = "v${version}";
    sha256 = "1wk23aq5lxsqns58s4g9jrwx6wrk7k9hq9rg8jcs42rxn2pckaxw";
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
