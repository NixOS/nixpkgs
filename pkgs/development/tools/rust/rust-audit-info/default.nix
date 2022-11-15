{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "rust-audit-info";
  version = "0.5.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-oxlbtFDQj6nyBXzNczG6ZhSOHvVQjK1FimWm/pSZHtY=";
  };

  cargoSha256 = "sha256-Y+5OUfsmUhDP9Fn8s9nso0W25eTFodDIVEVusn6HRmk=";

  meta = with lib; {
    description = "A command-line tool to extract the dependency trees embedded in binaries by cargo-auditable";
    homepage = "https://github.com/rust-secure-code/cargo-auditable/tree/master/rust-audit-info";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
