{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mdsh";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "zimbatm";
    repo = "mdsh";
    rev = "v${version}";
    sha256 = "1ki6w3qf8ipcf7ch5120mj16vs7yan8k9zjd25v8x6vbsd1iccgy";
  };

  cargoSha256 = "0x5fd47rjmzzmwgj14gbj0rbxwbphd7f63mis4ivwlwc9ikjxdxb";

  meta = with lib; {
    description = "Markdown shell pre-processor";
    homepage = "https://github.com/zimbatm/mdsh";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ zimbatm ];
  };
}
