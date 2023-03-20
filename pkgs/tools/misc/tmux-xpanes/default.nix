{ lib, stdenv, fetchFromGitHub, openssl, perl }:

stdenv.mkDerivation rec {
  pname = "tmux-xpanes";
  version = "4.1.3";

  src = fetchFromGitHub {
    owner = "greymd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-e0dEkkEkColBQ0PgOQpoVbIkR3aVsrMZoSGbg4O11SU=";
  };

  buildInputs = [ openssl perl ];

  installPhase = ''
    # Create directories.
    install -m 755 -d $out/bin/
    install -m 755 -d $out/share/man/man1/

    # Perform installation.
    install -m 755 bin/* $out/bin/
    install -m 644 man/*.1 $out/share/man/man1/
  '';

  meta = with lib; {
    description = "tmux-based terminal divider";
    homepage = "https://github.com/greymd/tmux-xpanes";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ monsieurp ];
  };
}
