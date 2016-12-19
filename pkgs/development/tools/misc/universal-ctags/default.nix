{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, perl }:

stdenv.mkDerivation rec {
  name = "universal-ctags-${version}";
  version = "2016-12-17";

  src = fetchFromGitHub {
    owner = "universal-ctags";
    repo = "ctags";
    rev = "3093f73e81cddbea5d122dccd4fd9a6323ebbbd3";
    sha256 = "091359v3p865d39gchpc1x5qplf1s1y4nsph344ng5x1nkx44qsi";
  };

  buildInputs = [ autoreconfHook pkgconfig ];

  autoreconfPhase = ''
    ./autogen.sh --tmpdir
  '';

  postConfigure = ''
    sed -i 's|/usr/bin/env perl|${perl}/bin/perl|' misc/optlib2c
  '';

  doCheck = true;

  checkFlags = "units";

  meta = with stdenv.lib; {
    description = "A maintained ctags implementation";
    homepage = "https://ctags.io/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    # universal-ctags is preferred over emacs's ctags
    priority = 1;
    maintainers = [ maintainers.mimadrid ];
  };
}
