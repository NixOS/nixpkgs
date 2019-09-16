{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  pname = "mtm";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "deadpixi";
    repo = pname;
    rev = version;
    sha256 = "0q23z1dfjz3qkmxqm0d8sg81gn6w1j2n2j6c9hk1kk7iv21v1zb0";
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
