{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "rsass";
  version = "0.28.0";

  src = fetchCrate {
    pname = "rsass-cli";
    inherit version;
    hash = "sha256-hBYZB/Jyzd89dylZn2tYdHr0IXCFgJi9TnvuoVqCR1A=";
  };

  cargoHash = "sha256-nVTYTjmHB/z5M5AyojbsuZNCa3JCiADWrgV5eb3bcUE=";

  meta = with lib; {
    description = "Sass reimplemented in rust with nom";
    homepage = "https://github.com/kaj/rsass";
    changelog = "https://github.com/kaj/rsass/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
