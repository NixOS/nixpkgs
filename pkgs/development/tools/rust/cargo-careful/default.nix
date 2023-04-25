{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-careful";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "RalfJung";
    repo = "cargo-careful";
    rev = "v${version}";
    hash = "sha256-oYwbRww+NFPV9q26vfuTdxTBp0kzWdgWl6MAXhir2lc=";
  };

  cargoHash = "sha256-8b718qYPFFstjl2LQ23IoQDikF9YV1Ao+pDg2tiXxsc=";

  meta = with lib; {
    description = "A tool to execute Rust code carefully, with extra checking along the way";
    homepage = "https://github.com/RalfJung/cargo-careful";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
