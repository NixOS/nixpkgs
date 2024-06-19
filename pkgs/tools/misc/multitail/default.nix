{ lib, stdenv, fetchFromGitHub, ncurses, pkg-config, cmake }:

stdenv.mkDerivation rec {
  version = "7.1.2";
  pname = "multitail";

  src = fetchFromGitHub {
    owner = "folkertvanheusden";
    repo = pname;
    rev = version;
    sha256 = "sha256-00NZI/KFcgEAkvESnx0KQFW1GvX6FgZLA4Z1Fv2qi+E=";
  };

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [ ncurses ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/multitail $out/bin
  '';

  hardeningDisable = [ "format" ];

  meta = {
    homepage = "https://github.com/folkertvanheusden/multitail";
    description = "tail on Steroids";
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
    mainProgram = "multitail";
  };
}
