{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "hexyl";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hLDx5OzCE5iA492V3+dhaav2l8/rOVWyskrU4Gz1hf4=";
  };

  cargoSha256 = "sha256-CGaCMrShagK4dAdwJtaeUMJlYOlG/cH+6E1QDYGrqL0=";

  meta = with lib; {
    changelog = "https://github.com/sharkdp/hexyl/releases/tag/v${version}";
    description = "A command-line hex viewer";
    longDescription = ''
      `hexyl` is a simple hex viewer for the terminal. It uses a colored
      output to distinguish different categories of bytes (NULL bytes,
      printable ASCII characters, ASCII whitespace characters, other ASCII
      characters and non-ASCII).
    '';
    homepage = "https://github.com/sharkdp/hexyl";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir SuperSandro2000 ];
  };
}
