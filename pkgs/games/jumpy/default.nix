{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, makeWrapper
, pkg-config
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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "fishfolk";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vBnHNc/kCyZ8gTWhQShn4lBQECguFBzBd7xIfLBgm7A=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "bevy_simple_tilemap-0.10.1" = "sha256-Q/AsBZjsr+uTIh/oN0OsIJxntZ4nuc1AReo0Ronj930=";
      "bones_asset-0.1.0" = "sha256-CyP7rbS3X26xlCFxn3g9YhZze7UeqxQ1wULrZ3er7Xc=";
    };
  };

  auditable = true; # TODO: remove when this is the default

  nativeBuildInputs = [
    makeWrapper
  ] ++ lib.optionals stdenv.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isLinux [
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
