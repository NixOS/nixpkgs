{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, perl, pythonPackages, libiconv }:

stdenv.mkDerivation rec {
  name = "universal-ctags-${version}";
  version = "2018-01-05";

  src = fetchFromGitHub {
    owner = "universal-ctags";
    repo = "ctags";
    rev = "c66bdfb4db99977c1bd0568e33e60853a48dca65";
    sha256 = "0fdzhr0704cj84ym00plkl5l9w83haal6i6w70lx6f4968pcliyi";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig pythonPackages.docutils ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin libiconv;

  # to generate makefile.in
  autoreconfPhase = ''
    ./autogen.sh
  '';

  configureFlags = [ "--enable-tmpdir=/tmp" ];

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
