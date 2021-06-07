{ lib, stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  pname = "mtm";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "deadpixi";
    repo = pname;
    rev = version;
    sha256 = "0b2arkmbmabxmrqxlpvvvhll2qx0xgj7r4r6p0ymnm9p70idris4";
  };

  buildInputs = [ ncurses ];

  preBuild = ''
    substituteInPlace Makefile --replace "strip -s mtm" ""
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin mtm
    install -Dm644 -t $out/share/man/man1 mtm.1

    runHook postInstall
  '';

  meta = with lib; {
    description = "Perhaps the smallest useful terminal multiplexer in the world";
    homepage = "https://github.com/deadpixi/mtm";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.marsam ];
  };
}
