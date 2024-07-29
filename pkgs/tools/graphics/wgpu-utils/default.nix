{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  makeWrapper,
  vulkan-loader,
  freetype,
  fontconfig,
  QuartzCore,
}:

rustPlatform.buildRustPackage rec {
  pname = "wgpu-utils";
  version = "22.0.0";

  src = fetchFromGitHub {
    owner = "gfx-rs";
    repo = "wgpu";
    rev = "v${version}";
    hash = "sha256-bc+W7lAIulCnlxHZjwwyIL3KfmeyEJ4yPegS/wIA9UU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "noise-0.8.2" = "sha256-7GvShJeSNfwMCBIfqLghXgKQv7EDMqVchJw0uxPhNr4=";
      "rspirv-0.11.0+sdk-1.2.198" = "sha256-AcJqkcXBr/+SHdUDXd63sQ0h5eosMqRhV4aUREJH8Bw=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    makeWrapper
  ];

  buildInputs = [
    freetype
    fontconfig
  ] ++ lib.optional stdenv.isDarwin QuartzCore;

  # Tests fail, as the Nix sandbox doesn't provide an appropriate adapter (e.g. Vulkan).
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/wgpu-info \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  meta = with lib; {
    description = "Safe and portable GPU abstraction in Rust, implementing WebGPU API";
    homepage = "https://wgpu.rs/";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ erictapen ];
    mainProgram = "wgpu-info";
  };
}
