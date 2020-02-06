{ stdenv, fetchFromGitHub, openssl, perl }:

stdenv.mkDerivation rec {
  pname = "tmux-xpanes";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "greymd";
    repo = pname;
    rev = "v${version}";
    sha256 = "11yz6rh2ckd1z8q80n8giv2gcz2i22fgf3pnfxq96qrzflb0d96a";
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
