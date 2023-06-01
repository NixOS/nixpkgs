{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "hexyl";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-c3CMtPLo5NfKfr2meccFuDpf0ffZ3uBw995TEB5FSTs=";
  };

  cargoHash = "sha256-2pIASIJ83lFfC7do/02MxY/OOMJG7McS6O8uRMy9kVs=";

  meta = with lib; {
    description = "A command-line hex viewer";
    longDescription = ''
      `hexyl` is a simple hex viewer for the terminal. It uses a colored
      output to distinguish different categories of bytes (NULL bytes,
      printable ASCII characters, ASCII whitespace characters, other ASCII
      characters and non-ASCII).
    '';
    homepage = "https://github.com/sharkdp/hexyl";
    changelog = "https://github.com/sharkdp/hexyl/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir figsoda SuperSandro2000 ];
  };
}
