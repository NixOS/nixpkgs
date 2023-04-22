{ lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
, makeWrapper
, pkg-config
, zstd
, stdenv
, alsa-lib
, libxkbcommon
, udev
, vulkan-loader
, wayland
, xorg
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "jumpy";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "fishfolk";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-03VPfSIlGB8Cc1jWzZSj9MBFBBmMjyx+RdHr3r3oolU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "bones_asset-0.1.0" = "sha256-YyY5OsbRLkpAgvNifRiXfmzfsgFw/oFV1nQVCkXG4j4=";
    };
  };

  patches = [
    # removes unused patch in patch.crates-io, which cases the build to fail
    # error: failed to load source for dependency `bevy_simple_tilemap`
    # Caused by: attempting to update a git repository, but --frozen was specified
    ./remove-unused-patch.patch

    # the crate version is outdated
    (fetchpatch {
      name = "bump-version-to-0-6-1.patch";
      url = "https://github.com/fishfolk/jumpy/commit/15081c425056cdebba1bc90bfcaba50a2e24829f.patch";
      hash = "sha256-dxLfy1HMdjh2VPbqMb/kwvDxeuptFi3W9tLzvg6TLsE=";
    })
  ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    zstd
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
    libxkbcommon
    udev
    vulkan-loader
    wayland
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Cocoa
    rustPlatform.bindgenHook
  ];

  cargoBuildFlags = [ "--bin" "jumpy" ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  postInstall = ''
    mkdir $out/share
    cp -r assets $out/share
    wrapProgram $out/bin/jumpy \
      --set-default JUMPY_ASSET_DIR $out/share/assets
  '';

  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf $out/bin/.jumpy-wrapped \
      --add-rpath ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  meta = with lib; {
    description = "A tactical 2D shooter played by up to 4 players online or on a shared screen";
    homepage = "https://fishfight.org/";
    changelog = "https://github.com/fishfolk/jumpy/releases/tag/v${version}";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
