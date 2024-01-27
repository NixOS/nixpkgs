{ lib
, rustPlatform
, fetchFromGitHub
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
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "fishfolk";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ggePJH2kKJ17aOWRKUnLyolIdSzlc6Axf5Iw74iFfek=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "bevy_egui-0.21.0" = "sha256-hu55tZQppw1NajwqIsYsw6de0IAwQwgra3D9OFzSSLc=";
      "bones_asset-0.3.0" = "sha256-1UeOXW6O/gMQBBUnHxRreJgmiUTPC5SJB+uLn9V8aa4=";
      "kira-0.8.5" = "sha256-z4R5aIaoRQQprL6JsVrFI69rwTOsW5OH01+jORS+hBQ=";
    };
  };

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
    darwin.apple_sdk_11_0.frameworks.Cocoa
    rustPlatform.bindgenHook
  ];

  cargoBuildFlags = [ "--bin" "jumpy" ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  # jumpy only loads assets from the current directory
  # https://github.com/fishfolk/bones/blob/f84d07c2f2847d9acd5c07098fe1575abc496400/framework_crates/bones_asset/src/io.rs#L50
  postInstall = ''
    mkdir $out/share
    cp -r assets $out/share
    wrapProgram $out/bin/jumpy --chdir $out/share
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
