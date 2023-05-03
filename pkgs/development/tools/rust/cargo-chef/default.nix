{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-chef";
  version = "0.1.56";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-WsK4hdV20IcG2bF8LumeII8e91330zCtR0+A3EPYtAk=";
  };

  cargoHash = "sha256-L/4m47TJHGSOC8/94qnjea5Febck7RtPaVVYi4/Pn5s=";

  meta = with lib; {
    description = "A cargo-subcommand to speed up Rust Docker builds using Docker layer caching";
    homepage = "https://github.com/LukeMathWalker/cargo-chef";
    license = licenses.mit;
    maintainers = with maintainers; [ kkharji ];
  };
}
