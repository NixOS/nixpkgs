{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, stdenv
, darwin
, libxkbcommon
, wayland
}:

rustPlatform.buildRustPackage {
  pname = "cargo-bundle";
  # the latest stable release fails to build on darwin
  version = "unstable-2023-03-17";

  src = fetchFromGitHub {
    owner = "burtonageo";
    repo = "cargo-bundle";
    rev = "eb9fe1b0880c7c0e929a93edaddcb0a61cd3f0d4";
    hash = "sha256-alO+Q9IK5Hz09+TqHWsbjuokxISKQfQTM6QnLlUNydw=";
  };

  cargoHash = "sha256-h+QPbwYTJk6dieta/Q+VAhYe8/YH/Nik6gslzUn0YxI=";

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
