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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "kdash-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Vk0Pf5uF9AANv/vf32ZrICJJTp6QRsR/nFW40xnkImo=";
  };

  nativeBuildInputs = [ perl python3 pkg-config ];

  buildInputs = [ openssl xorg.xcbutil ]
    ++ lib.optional stdenv.isDarwin AppKit;

  cargoHash = "sha256-gY4ywjTokEc5Uv4InARH2s3WYiPGYSDDWk2kltyQa+0=";

  meta = with lib; {
    description = "A simple and fast dashboard for Kubernetes";
    homepage = "https://github.com/kdash-rs/kdash";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
