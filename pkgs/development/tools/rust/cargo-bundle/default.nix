{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  darwin,
  libxkbcommon,
  wayland,
}:

rustPlatform.buildRustPackage {
  pname = "cargo-bundle";
  # the latest stable release fails to build on darwin
  version = "unstable-2023-08-18";

  src = fetchFromGitHub {
    owner = "burtonageo";
    repo = "cargo-bundle";
    rev = "c9f7a182d233f0dc4ad84e10b1ffa0d44522ea43";
    hash = "sha256-n+c83pmCvFdNRAlcadmcZvYj+IRqUYeE8CJVWWYbWDQ=";
  };

  cargoHash = "sha256-Ea658jHomktmzXtU5wmd0bRX+i5n46hCvexYxYbjjUc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.AppKit
    ]
    ++ lib.optionals stdenv.isLinux [
      libxkbcommon
      wayland
    ];

  meta = with lib; {
    description = "Wrap rust executables in OS-specific app bundles";
    mainProgram = "cargo-bundle";
    homepage = "https://github.com/burtonageo/cargo-bundle";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
