{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name    = "hexyl-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = "hexyl";
    rev    = "v${version}";
    sha256 = "09h01y0r7km0vgljgc8bgiswbrq47id408vpya2da4mijbg4h82r";
  };

  cargoSha256 = "1zy2jvzx62yjaiq25560krz1648vqwfr5kjbq3wz7nlmf1cs7s2c";

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
