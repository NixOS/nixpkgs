{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, perl, pythonPackages, libiconv }:

stdenv.mkDerivation rec {
  name = "universal-ctags-${version}";
  version = "2018-07-23";

  src = fetchFromGitHub {
    owner = "universal-ctags";
    repo = "ctags";
    rev = "3522685695ad3312cf4b19399e0c44f3395dd089";
    sha256 = "1f67hy8c2yr9z4ydsqd7wg8iagzn01qjw2ccx6g8mngv3i3jz9mv";
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
