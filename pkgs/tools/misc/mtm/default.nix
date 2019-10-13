{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  pname = "mtm";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "deadpixi";
    repo = pname;
    rev = version;
    sha256 = "0k9xachd9wnyhj8sh4yninckgwm3a7zdxnn490x65ikn4vqb7w8x";
  };

  buildInputs = [ ncurses ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin mtm
    install -Dm644 -t $out/share/man/man1 mtm.1

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Perhaps the smallest useful terminal multiplexer in the world";
    homepage = "https://github.com/deadpixi/mtm";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.marsam ];
  };
}
