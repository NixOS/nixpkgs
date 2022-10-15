{ lib, stdenv, fetchFromGitHub, fetchpatch, ncurses, pkg-config, cmake }:

stdenv.mkDerivation rec {
  version = "7.0.0";
  pname = "multitail";

  src = fetchFromGitHub {
    owner = "folkertvanheusden";
    repo = pname;
    rev = version;
    sha256 = "sha256-AMW55Bmwn0BsD36qGXI5WmEfydrMBob8NRY3Tyq92vA=";
  };

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [ ncurses ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/multitail $out/bin
  '';

  hardeningDisable = [ "format" ];

  meta = {
    homepage = "https://github.com/halturin/multitail";
    description = "tail on Steroids";
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
  };
}
