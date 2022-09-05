{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "hexyl";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-LskDHUm45OlWbzlumaIXPXCZEBA5dXanhzgAvenJgVk=";
  };

  cargoSha256 = "sha256-qKk95hGcThu0y3ND9z3mXw1TBaVkwAOrznaqj2k3SEk=";

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
