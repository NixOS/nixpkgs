{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname   = "hexyl";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1n2q5a6697bxvl0askywhad2x560cajv456gxihdqqmmyq2vf63h";
  };

  cargoSha256 = "1wcpbqlglf9r0xhfjmyym8bnd4pgrsf9lrmb14hn1ml5zlshpd7p";

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
