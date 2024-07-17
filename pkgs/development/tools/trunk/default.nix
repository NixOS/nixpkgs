{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  jq,
  moreutils,
  CoreServices,
  SystemConfiguration,
}:

rustPlatform.buildRustPackage rec {
  pname = "trunk";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "trunk-rs";
    repo = "trunk";
    rev = "v${version}";
    hash = "sha256-VcTlXGfNfkbFoJiNmOp0AS0/NApgTaiZEafZSV2PuTI=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    if stdenv.isDarwin then
      [
        CoreServices
        SystemConfiguration
      ]
    else
      [ openssl ];
  # requires network
  checkFlags = [ "--skip=tools::tests::download_and_install_binaries" ];

  cargoHash = "sha256-jXp6B9eTYKfDgzzgp1oRMzwVJOzsh9h0+igQLBZmdsk=";

  meta = with lib; {
    homepage = "https://github.com/trunk-rs/trunk";
    description = "Build, bundle & ship your Rust WASM application to the web";
    mainProgram = "trunk";
    maintainers = with maintainers; [
      freezeboy
      ctron
    ];
    license = with licenses; [ asl20 ];
  };
}
