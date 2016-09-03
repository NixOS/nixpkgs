{ stdenv, pkgconfig, fetchFromGitHub, python, glib, vala_0_28, ctpl
, libgee, libsoup, fcgi }:

stdenv.mkDerivation rec {
  name = "valum-${version}";
  version = "0.2.16";

  src = fetchFromGitHub {
    owner = "valum-framework";
    repo = "valum";
    rev = "v${version}";
    sha256 = "0ca067gg5z1798bazwzgg2yd2mbysvk8i2q2v3i8d0d188y2hj84";
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
