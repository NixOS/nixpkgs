{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "specr-transpile";
  version = "0.1.24";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-+7NjB87pfFh8472gOV4HoKIqSiHnTCFOEVdKYBsn1qg=";
  };

  cargoHash = "sha256-VgEyXm1uSsNJVjUYx66A35vLNxYErTrC8qBhYVlYyH4=";

  meta = with lib; {
    description = "Converts Specr lang code to Rust";
    homepage = "https://github.com/RalfJung/minirust-tooling";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
