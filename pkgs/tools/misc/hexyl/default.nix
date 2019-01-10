{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name    = "hexyl-${version}";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = "hexyl";
    rev    = "v${version}";
    sha256 = "138w6czi62dpw6gcd3yqpk7lns7m89kwbgm1d1i5lnzsqck3wb4s";
  };

  cargoSha256 = "01m8n7yl3yqr8kj0dl1wfaz724da17hs3sb1fbncv64l6qpvdka1";

  meta = with stdenv.lib; {
    description = "A command-line hex viewer";
    longDescription = ''
      `hexyl` is a simple hex viewer for the terminal. It uses a colored
      output to distinguish different categories of bytes (NULL bytes,
      printable ASCII characters, ASCII whitespace characters, other ASCII
      characters and non-ASCII).
    '';
    homepage    = https://github.com/sharkdp/hexyl;
    license     = with licenses; [ asl20 /* or */ mit ];
    maintainers = [];
    platforms   = platforms.linux ++ platforms.darwin;
  };
}
