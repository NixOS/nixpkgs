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
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "kdash-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1vBa6BAn9+T1C3ZxseMvLQHIlU0WUYShUQE3YKleoc4=";
  };

  nativeBuildInputs = [ perl python3 pkg-config ];

  buildInputs = [ openssl xorg.xcbutil ]
    ++ lib.optional stdenv.isDarwin AppKit;

  cargoHash = "sha256-dtuUkS5Je8u4DcjNgQFVVX+ACP0RBLXUYNB+EwKajzo=";

  meta = with lib; {
    description = "A simple and fast dashboard for Kubernetes";
    homepage = "https://github.com/kdash-rs/kdash";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
