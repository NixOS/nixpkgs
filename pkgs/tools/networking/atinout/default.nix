{
  lib,
  stdenv,
  fetchgit,
  ronn,
  mount,
}:

stdenv.mkDerivation rec {
  pname = "atinout";
  version = "0.9.2-alpha";

  env.NIX_CFLAGS_COMPILE = lib.optionalString (!stdenv.cc.isClang) "-Werror=implicit-fallthrough=0";
  LANG = if stdenv.isDarwin then "en_US.UTF-8" else "C.UTF-8";
  nativeBuildInputs = [
    ronn
    mount
  ];

  src = fetchgit {
    url = "git://git.code.sf.net/p/atinout/code";
    rev = "4976a6cb5237373b7e23cd02d7cd5517f306e3f6";
    sha256 = "0bninv2bklz7ly140cxx8iyaqjlq809jjx6xqpimn34ghwsaxbpv";
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    make PREFIX=$out install
  '';

  meta = with lib; {
    homepage = "https://atinout.sourceforge.net";
    description = "Tool for talking to modems";
    platforms = platforms.unix;
    license = licenses.gpl3;
    maintainers = with maintainers; [ bendlas ];
    mainProgram = "atinout";
  };
}
