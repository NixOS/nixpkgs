{ stdenv, fetchgit, ronn, mount }:

stdenv.mkDerivation rec {
  name = "atinout-${version}";
  version = "0.9.2-alpha";

  NIX_CFLAGS_COMPILE = "-Werror=implicit-fallthrough=0";
  LANG = "C.UTF-8";
  nativeBuildInputs = [ ronn mount ];

  src = fetchgit {
    url = "git://git.code.sf.net/p/atinout/code";
    rev = "4976a6cb5237373b7e23cd02d7cd5517f306e3f6";
    sha256 = "0bninv2bklz7ly140cxx8iyaqjlq809jjx6xqpimn34ghwsaxbpv";
  };

  installPhase = ''
    make PREFIX=$out install
  '';

  meta = with stdenv.lib; {
    homepage = http://atinout.sourceforge.net;
    description = "Tool for talking to modems";
    platforms = platforms.unix;
    license = licenses.gpl3;
    maintainers = with maintainers; [ bendlas ];
  };
}
