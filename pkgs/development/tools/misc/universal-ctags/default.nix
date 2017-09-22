{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, perl }:

stdenv.mkDerivation rec {
  name = "universal-ctags-${version}";
  version = "2017-01-08";

  src = fetchFromGitHub {
    owner = "universal-ctags";
    repo = "ctags";
    rev = "9668032d8715265ca5b4ff16eb2efa8f1c450883";
    sha256 = "0nwcf5mh3ba0g23zw7ym73pgpfdass412k2fy67ryr9vnc709jkj";
  };

  buildInputs = [ autoreconfHook pkgconfig ];

  # remove when https://github.com/universal-ctags/ctags/pull/1267 is merged
  patches = [ ./sed-test.patch ];

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
    homepage = https://ctags.io/;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    # universal-ctags is preferred over emacs's ctags
    priority = 1;
    maintainers = [ maintainers.mimadrid ];
  };
}
