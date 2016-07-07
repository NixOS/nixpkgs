{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, perl }:

stdenv.mkDerivation rec {
  name = "universal-ctags-${version}";
  version = "2016-07-06";

  src = fetchFromGitHub {
    owner = "universal-ctags";
    repo = "ctags";
    rev = "44a325a9db23063b231f6f041af9aaf19320d9b9";
    sha256 = "11vq901h121ckqgw52k9x7way3q38b7jd08vr1n2sjz7kxh0zdd0";
  };

  buildInputs = [ autoreconfHook pkgconfig ];

  autoreconfPhase = ''
    ./autogen.sh --tmpdir
  '';

  postConfigure = ''
    sed -i 's|/usr/bin/env perl|${perl}/bin/perl|' misc/optlib2c
  '';

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
