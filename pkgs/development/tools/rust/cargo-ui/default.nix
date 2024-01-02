{ lib
, rustPlatform
, fetchCrate
, pkg-config
, libgit2_1_5
, openssl
, stdenv
, expat
, fontconfig
, libGL
, xorg
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-ui";
  version = "0.3.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-M/ljgtTHMSc7rY/a8CpKGNuOSdVDwRt6+tzPPHdpKOw=";
  };

  cargoHash = "sha256-u3YqXQZCfveSBjxdWb+GC0IA9bpruAYQdxX1zanT3fw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2_1_5
    openssl
  ] ++ lib.optionals stdenv.isLinux [
    expat
    fontconfig
    libGL
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
    xorg.libxcb
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ];

  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf $out/bin/cargo-ui \
      --add-rpath ${lib.makeLibraryPath [ fontconfig libGL ]}
  '';

  meta = with lib; {
    description = "A GUI for Cargo";
    homepage = "https://github.com/slint-ui/cargo-ui";
    changelog = "https://github.com/slint-ui/cargo-ui/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit asl20 gpl3Only ];
    maintainers = with maintainers; [ figsoda matthiasbeyer ];
  };
}
