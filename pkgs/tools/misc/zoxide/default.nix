{ lib
, fetchFromGitHub
, rustPlatform
, fzf
}:

rustPlatform.buildRustPackage rec {
  pname = "zoxide";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "ajeetdsouza";
    repo = "zoxide";
    rev = "v${version}";
    sha256 = "1sad18d0pxfdy9gvjmixzgdskg1l7djvzp0aipx7pz0lyi6gs23z";
  };

  buildInputs = [
    fzf
  ];

  cargoSha256 = "1sx3s1jnfxylbjr3x6v6j8a6zkl7hfyj4alzlyrsw36b1b64pwqm";

  meta = with lib; {
    description = "A fast cd command that learns your habits";
    homepage = "https://github.com/ajeetdsouza/zoxide";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ysndr cole-h ];
    platforms = platforms.all;
  };
}
