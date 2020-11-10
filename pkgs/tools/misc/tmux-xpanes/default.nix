{ stdenv, fetchFromGitHub, openssl, perl }:

stdenv.mkDerivation rec {
  pname = "tmux-xpanes";
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "greymd";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vm5mi6dqdbg0b5qh4r8sr1plpc00jryd8a2qxpp3a72cigjvvf0";
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

  meta = with stdenv.lib; {
    description = "tmux-based terminal divider";
    homepage = "https://github.com/greymd/tmux-xpanes";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ monsieurp ];
  };
}
