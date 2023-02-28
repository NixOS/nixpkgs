{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "rsass";
  version = "0.27.0";

  src = fetchCrate {
    pname = "rsass-cli";
    inherit version;
    sha256 = "sha256-IaXfxccRRY868waEPI7qbWp1SSAhJlRqgeEiRNddC/c=";
  };

  cargoSha256 = "sha256-2owdX9ePHcAXpE43Svan252lAa5ICk0/DrDeADegZ6U=";

  meta = with lib; {
    description = "Sass reimplemented in rust with nom";
    homepage = "https://github.com/kaj/rsass";
    changelog = "https://github.com/kaj/rsass/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
