{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, perl
, python3
, openssl
, xorg
, AppKit
}:

rustPlatform.buildRustPackage rec {
  pname = "kdash";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "kdash-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-IpF5uXRxHBmfWkBBJjNvDsyQG5nzFjKbCmmGpG3howo=";
  };

  nativeBuildInputs = [ perl python3 pkg-config ];

  buildInputs = [ openssl xorg.xcbutil ]
    ++ lib.optional stdenv.hostPlatform.isDarwin AppKit;

  cargoHash = "sha256-jm0UCKDy6TrogMPavB86lvk8yKZXubTGGbApk+oP2RQ=";

  meta = with lib; {
    description = "Simple and fast dashboard for Kubernetes";
    mainProgram = "kdash";
    homepage = "https://github.com/kdash-rs/kdash";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
