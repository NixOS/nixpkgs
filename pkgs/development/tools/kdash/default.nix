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
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "kdash-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qaPRC5W+dLNbrCYc8fKdaSm54OuObJ20tVYCF7ZANYs=";
  };

  nativeBuildInputs = [ perl python3 pkg-config ];

  buildInputs = [ openssl xorg.xcbutil ]
    ++ lib.optional stdenv.isDarwin AppKit;

  cargoHash = "sha256-Z//EsuizhCZIItKfxF8xJs0aQQlhiprV0I2cIWEGsqg=";

  meta = with lib; {
    description = "A simple and fast dashboard for Kubernetes";
    homepage = "https://github.com/kdash-rs/kdash";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
