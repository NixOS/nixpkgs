{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  perl,
  python3,
  openssl,
  xorg,
  AppKit,
}:

rustPlatform.buildRustPackage rec {
  pname = "kdash";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "kdash-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fFpdWVoeWycnp/hRw2S+hYpnXYmCs+rLqcZdmSSMGwI=";
  };

  nativeBuildInputs = [
    perl
    python3
    pkg-config
  ];

  buildInputs = [
    openssl
    xorg.xcbutil
  ] ++ lib.optional stdenv.hostPlatform.isDarwin AppKit;

  useFetchCargoVendor = true;
  cargoHash = "sha256-72DuM64wj8WW6soagodOFIeHvVn1CPpb1T3Y7GQYsbs=";

  meta = with lib; {
    description = "Simple and fast dashboard for Kubernetes";
    mainProgram = "kdash";
    homepage = "https://github.com/kdash-rs/kdash";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
