{ lib,
stdenv,
rustPlatform,
fetchFromGitHub,
pkg-config,
openssl,
jq,
moreutils,
CoreServices,
SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "trunk";
  version = "0.20.2";

  src = fetchFromGitHub {
    owner = "trunk-rs";
    repo = "trunk";
    rev = "v${version}";
    hash = "sha256-hyjv3UJWIfJjdGtju4T6ufhz97F76uib/B9kyBHsC64=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = if stdenv.isDarwin
    then [ CoreServices SystemConfiguration ]
    else [ openssl ];
  # requires network
  checkFlags = [ "--skip=tools::tests::download_and_install_binaries" ];

  cargoHash = "sha256-BI/jA5/7/QP62EtOXXRkbsJILsHbVacZY/bKZGcXk34=";

  meta = with lib; {
    homepage = "https://github.com/trunk-rs/trunk";
    description = "Build, bundle & ship your Rust WASM application to the web";
    mainProgram = "trunk";
    maintainers = with maintainers; [ freezeboy ctron ];
    license = with licenses; [ asl20 ];
  };
}
