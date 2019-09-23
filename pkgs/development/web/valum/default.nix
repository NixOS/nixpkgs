{ stdenv, meson, ninja, pkgconfig, fetchFromGitHub, glib, vala, ctpl
, libgee, libsoup, fcgi }:

stdenv.mkDerivation rec {
  pname = "valum";
  version = "0.3.16";

  src = fetchFromGitHub {
    owner = "valum-framework";
    repo = "valum";
    rev = "v${version}";
    sha256 = "15lnk91gykm60rv31x3r1swp2bhzl3gwp12mf39smzi4bmf7h38f";
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
