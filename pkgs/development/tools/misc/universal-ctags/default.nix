{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, perl, pythonPackages, libiconv }:

stdenv.mkDerivation rec {
  name = "universal-ctags-${version}";
  version = "2017-09-22";

  src = fetchFromGitHub {
    owner = "universal-ctags";
    repo = "ctags";
    rev = "b9537289952cc7b26526aaff3094599d714d1729";
    sha256 = "1kbw9ycl2ddzpfs1v4rbqa4gdhw4inrisf4awyaxb7zxfxmbzk1g";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig pythonPackages.docutils ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin libiconv;

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
