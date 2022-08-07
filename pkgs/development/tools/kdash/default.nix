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
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "kdash-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-u5Qa1rStWeFku3VA2ljg+RQxh12byfyBHXC+NQJTr0w=";
  };

  nativeBuildInputs = [ perl python3 pkg-config ];

  buildInputs = [ openssl xorg.xcbutil ]
    ++ lib.optional stdenv.isDarwin AppKit;

  cargoSha256 = "sha256-rSPe7kkeHEYDqF80oO+Z+bGkWewtjnKut13EP6tmUIc=";

  meta = with lib; {
    description = "A simple and fast dashboard for Kubernetes";
    homepage = "https://github.com/kdash-rs/kdash";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
