{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, stdenv
, darwin
, libxkbcommon
, wayland
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bundle";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "burtonageo";
    repo = "cargo-bundle";
    rev = "v${version}";
    hash = "sha256-MKr6qLWWrU3thBhKpmH8OxIEKvzb0/cwhyLJlE9B8lA=";
  };

  cargoHash = "sha256-xZewlGRfxndUO43cjiYRw5gQMJgvJ5Iu/RxoQeAOR2k=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ] ++ lib.optionals stdenv.isLinux [
    libxkbcommon
    wayland
  ];

  meta = with lib; {
    description = "Wrap rust executables in OS-specific app bundles";
    homepage = "https://github.com/burtonageo/cargo-bundle";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
