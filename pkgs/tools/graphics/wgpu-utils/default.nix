{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, makeWrapper, vulkan-loader, QuartzCore }:

rustPlatform.buildRustPackage rec {
  pname = "wgpu-utils";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "gfx-rs";
    repo = "wgpu";
    rev = "v${version}";
    hash = "sha256-jHjV2A949m/KyAkkdaP00d5j+V96jRQah4LKs8LcYQk=";
  };

  cargoHash = "sha256-XbEgcPLL3UZ4zdV90AEFI8RlkZAMuLXznlkBcAG/0l8=";

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
    description = "Safe and portable GPU abstraction in Rust, implementing WebGPU API.";
    homepage = "https://wgpu.rs/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ erictapen ];
    mainProgram = "wgpu-info";
  };
}
