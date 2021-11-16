{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, perl
, python3
, openssl
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "kdash";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "kdash-rs";
    repo = pname;
    rev = "v${version}";
    sha256 = "09f9qkab2scass4p2vxkhyqslcf32kvpxi1zfa23p72v681jp0c8";
  };

  nativeBuildInputs = [ perl python3 pkg-config ];

  buildInputs = [ openssl xorg.xcbutil ];

  cargoSha256 = "0jbyvjgxcjw610nd2i6d3jfmhv1lwsl8ss4fd3kwczsms28frx5c";

  meta = with lib; {
    description = "A simple and fast dashboard for Kubernetes";
    homepage = "https://github.com/kdash-rs/kdash";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
