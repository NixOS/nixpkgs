{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  vulkan-loader,
  QuartzCore,
}:

rustPlatform.buildRustPackage rec {
  pname = "wgpu-utils";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "gfx-rs";
    repo = "wgpu";
    rev = "v${version}";
    hash = "sha256-tGjjjQDcN9zkxQSOrW/D1Pu6cycTKo/lh71mTEpZQIE=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "d3d12-0.6.0" = "sha256-xCazXUriIQWMVa3DOI1aySBATmYwyDqsVYULRV2l/44=";
      "naga-0.12.0" = "sha256-EZ8ZKixOFPT9ZTKIC/UGh2B3F09ENbCTUi+ASamJzMM=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = lib.optional stdenv.isDarwin QuartzCore;

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
