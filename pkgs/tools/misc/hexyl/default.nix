{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name    = "hexyl-${version}";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = "hexyl";
    rev    = "v${version}";
    sha256 = "1q4klph45a7zjzwajrccb51yc3k1p16mjlnqislpm43h653f728q";
  };

  cargoSha256 = "17mp6amib58akh175qprqsz3qkffgdacfm3dhkbysiqmw5m2p2p7";

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
    maintainers = with maintainers; [ dywedir ];
    platforms   = platforms.linux ++ platforms.darwin;
  };
}
