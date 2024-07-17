{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-chef";
  version = "0.1.67";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-5bvA3lss+F2Wx0SSx5KRCmpERdIXUkUhFP+zRn8aZH0=";
  };

  cargoHash = "sha256-EIpi1k5GffGCk+fzHSW32T+ZLkRfswnEGZdER95TyBk=";

  meta = with lib; {
    description = "Cargo-subcommand to speed up Rust Docker builds using Docker layer caching";
    mainProgram = "cargo-chef";
    homepage = "https://github.com/LukeMathWalker/cargo-chef";
    license = licenses.mit;
    maintainers = with maintainers; [ kkharji ];
  };
}
