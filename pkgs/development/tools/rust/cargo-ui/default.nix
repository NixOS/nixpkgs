{ lib
, rustPlatform
, fetchCrate
, pkg-config
, makeWrapper
, libgit2
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
  version = "0.3.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-IL7BxiJg6eTuFM0pJ3qLxYCVofE/RjmgQjvOW96QF9A=";
  };

  # update dependencies so it is compatible with libgit2 1.5
  # libgit2-sys 0.14.3 is only compatible with libgit2 1.4
  cargoPatches = [ ./update-git2.patch ];

  cargoSha256 = "sha256-i/ERVPzAWtN4884051VoA/ItypyURpHb/Py6w3KDOAo=";

  nativeBuildInputs = [
    pkg-config
  ] ++ lib.optionals stdenv.isLinux [
    makeWrapper
  ];

  buildInputs = [
    libgit2
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
    # dark-light doesn't build on apple sdk < 10.14
    # see https://github.com/frewsxcv/rust-dark-light/issues/14
    darwin.apple_sdk_11_0.frameworks.AppKit
  ];

  postInstall = lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/cargo-ui \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libGL ]}
  '';

  meta = with lib; {
    description = "A GUI for Cargo";
    homepage = "https://github.com/slint-ui/cargo-ui";
    changelog = "https://github.com/slint-ui/cargo-ui/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit asl20 gpl3Only ];
    maintainers = with maintainers; [ figsoda ];
  };
}
