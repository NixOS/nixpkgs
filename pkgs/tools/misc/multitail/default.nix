{ lib, stdenv, fetchFromGitHub, fetchpatch, ncurses, pkg-config }:

stdenv.mkDerivation rec {
  version = "6.5.2";
  pname = "multitail";

  src = fetchFromGitHub {
    owner = "halturin";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DMYcoHOaX4bToDE8qpXmg5tbTYGkiwtPJd0/qy4uD54=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ ncurses ];

  makeFlags = lib.optionals stdenv.isDarwin [ "-f" "makefile.macosx" ];

  installPhase = ''
    mkdir -p $out/bin
    cp multitail $out/bin
  '';

  meta = {
    homepage = "https://github.com/halturin/multitail";
    description = "tail on Steroids";
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
  };
}
