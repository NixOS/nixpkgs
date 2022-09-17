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
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "kdash-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hh/Q3wUsA6HM0PwMlSfWx9LX+h/Y9w/fXm4HMYXexZU=";
  };

  nativeBuildInputs = [ perl python3 pkg-config ];

  buildInputs = [ openssl xorg.xcbutil ]
    ++ lib.optional stdenv.isDarwin AppKit;

  cargoSha256 = "sha256-02AfMbR8TsIqEhkXAnslnxgO/XkyEuCW1IyBtrk1dDA=";

  meta = with lib; {
    description = "A simple and fast dashboard for Kubernetes";
    homepage = "https://github.com/kdash-rs/kdash";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
