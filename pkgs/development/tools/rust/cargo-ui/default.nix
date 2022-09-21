{ lib
, rustPlatform
, fetchCrate
, cmake
, pkg-config
, makeWrapper
, openssl
, stdenv
, fontconfig
, libGL
, libX11
, libXcursor
, libXi
, libXrandr
, libxcb
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-ui";
  version = "0.3.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-IL7BxiJg6eTuFM0pJ3qLxYCVofE/RjmgQjvOW96QF9A=";
  };

  cargoSha256 = "sha256-16mgp7GsjbizzCWN3MDpl6ps9CK1zdIpLiyNiKYjDI4=";

  nativeBuildInputs = [ cmake pkg-config ] ++ lib.optionals stdenv.isLinux [
    makeWrapper
  ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isLinux [
    fontconfig
    libGL
    libX11
    libXcursor
    libXi
    libXrandr
    libxcb
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
    # figsoda: I can't figure how to make it build on darwin
    broken = stdenv.isDarwin;
  };
}
