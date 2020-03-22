{ stdenv, fetchFromGitHub, rustPlatform, fzf }:

rustPlatform.buildRustPackage rec {
  pname = "zoxide";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "ajeetdsouza";
    repo = "zoxide";
    rev = "v${version}";
    sha256 = "0ldqhzkpbqjc1in0d0f7b06b8gim4sbh292qcbwhf5abyrhbm3m8";
  };

  buildInputs = [
    fzf
  ];

  cargoSha256 = "1grrqbdy37p3r857gz956h0ls922ma5fz6f8fb3vx7wc98rap621";

  meta = with stdenv.lib; {
    description = "A fast cd command that learns your habits";
    homepage = "https://github.com/ajeetdsouza/zoxide";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ysndr ];
    platforms = platforms.all;
  };
}
