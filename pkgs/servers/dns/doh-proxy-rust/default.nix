{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  Security,
  libiconv,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "doh-proxy-rust";
  version = "0.9.9";

  src = fetchCrate {
    inherit version;
    crateName = "doh-proxy";
    sha256 = "sha256-KvEayC+aY8aC5fSVIV9urNwLJcIfDMaAU+XdlGSmYRI=";
  };

  cargoHash = "sha256-eoC90ht9cbMLkPN3S4jxZipbFoZDTU7pIr6GRagGlJE=";

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
    libiconv
  ];

  passthru.tests = { inherit (nixosTests) doh-proxy-rust; };

  meta = with lib; {
    homepage = "https://github.com/jedisct1/doh-server";
    description = "Fast, mature, secure DoH server proxy written in Rust";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ stephank ];
    mainProgram = "doh-proxy";
  };
}
