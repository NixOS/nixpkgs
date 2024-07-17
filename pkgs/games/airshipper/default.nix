{
  lib,
  rustPlatform,
  fetchFromGitLab,
  openssl,
  libGL,
  vulkan-loader,
  wayland,
  wayland-protocols,
  libxkbcommon,
  libX11,
  libXrandr,
  libXi,
  libXcursor,
  udev,
  alsa-lib,
  stdenv,
  libxcb,
  pkg-config,
  makeWrapper,
  writeShellScript,
  patchelf,
}:
let
  version = "0.10.0";
  # Patch for airshipper to install veloren
  patch =
    let
      runtimeLibs = [
        udev
        alsa-lib
        stdenv.cc.cc.lib
        libxkbcommon
        libxcb
        libX11
        libXcursor
        libXrandr
        libXi
        vulkan-loader
        libGL
      ];
    in
    writeShellScript "patch" ''
      echo "making binaries executable"
      chmod +x {veloren-voxygen,veloren-server-cli}
      echo "patching dynamic linkers"
      ${patchelf}/bin/patchelf \
        --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" \
        veloren-server-cli
      ${patchelf}/bin/patchelf \
        --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" \
        --set-rpath "${lib.makeLibraryPath runtimeLibs}" \
        veloren-voxygen
    '';
in
rustPlatform.buildRustPackage {
  pname = "airshipper";
  inherit version;

  src = fetchFromGitLab {
    owner = "Veloren";
    repo = "airshipper";
    rev = "v${version}";
    hash = "sha256-5zP1Ye1fJNQp8eWKwdxLqBr4qzBfWEEBsJ9s7+8idL4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "octocrab-0.15.4" = "sha256-uKHLlb0EyWF0Ho8FP38DFZsEWXiAG8FEYzJgwO9W90U=";
    };
  };

  buildInputs = [
    openssl
    wayland
    wayland-protocols
    libxkbcommon
    libX11
    libXrandr
    libXi
    libXcursor
  ];
  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  RUSTC_BOOTSTRAP = 1; # We need rust unstable features

  postInstall = ''
    install -Dm444 -t "$out/share/applications" "client/assets/net.veloren.airshipper.desktop"
    install -Dm444    "client/assets/net.veloren.airshipper.png"  "$out/share/icons/net.veloren.airshipper.png"
  '';

  postFixup =
    let
      libPath = lib.makeLibraryPath [
        libGL
        vulkan-loader
        wayland
        wayland-protocols
        libxkbcommon
        libX11
        libXrandr
        libXi
        libXcursor
      ];
    in
    ''
      patchelf --set-rpath "${libPath}" "$out/bin/airshipper"
      wrapProgram "$out/bin/airshipper" --set VELOREN_PATCHER "${patch}"
    '';

  doCheck = false;
  cargoBuildFlags = [
    "--package"
    "airshipper"
  ];
  cargoTestFlags = [
    "--package"
    "airshipper"
  ];

  meta = with lib; {
    description = "Provides automatic updates for the voxel RPG Veloren";
    mainProgram = "airshipper";
    homepage = "https://www.veloren.net";
    license = licenses.gpl3;
    maintainers = with maintainers; [ yusdacra ];
  };
}
