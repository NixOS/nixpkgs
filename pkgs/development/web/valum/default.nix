{ stdenv, pkgconfig, fetchFromGitHub, python, glib, vala_0_28, ctpl
, libgee, libsoup, fcgi }:

stdenv.mkDerivation rec {
  name = "valum-${version}";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "valum-framework";
    repo = "valum";
    rev = "v${version}";
    sha256 = "1lciwqk4k9sf1hl4drl207g0ydlxl906kx9lx5fqhfb8gwcfqh2g";
  };

  buildInputs = [ python pkgconfig glib vala_0_28 ctpl libgee libsoup fcgi ];

  configurePhase = ''python waf configure --prefix=$out'';

  buildPhase = ''python waf build'';

  installPhase = ''python waf install'';

  meta = with stdenv.lib; {
    homepage = https://github.com/valum-framework/valum;
    description = "Web micro-framework written in Vala";
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };
}
