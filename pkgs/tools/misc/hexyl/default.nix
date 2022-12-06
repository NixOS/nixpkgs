{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "hexyl";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Y/zEJx+tUYCA/Clvwvnsy7L3whIXT7e5bgluhrOOPjM=";
  };

  cargoHash = "sha256-NpEwuVz0tFkbUZQ4W+ojeD3omEXZ7YRqDmy/zLe5Z1o=";

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
