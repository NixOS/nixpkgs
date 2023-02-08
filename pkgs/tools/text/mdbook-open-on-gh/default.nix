{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-open-on-gh";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    rev = version;
    hash = "sha256-uXfvE34yRrTUjh/HTMvOeZVxX4Drt6sxziaazg0CR3I=";
  };

  cargoHash = "sha256-ol06ErggVLw2ThpXq9NRWEr7ymDSEBN4ae5zUmHKa7k=";

  meta = with lib; {
    description = "mdbook preprocessor to add a open-on-github link on every page";
    homepage = "https://github.com/badboy/mdbook-open-on-gh";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
