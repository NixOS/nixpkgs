{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, makeWrapper, vulkan-loader, QuartzCore }:

rustPlatform.buildRustPackage rec {
  pname = "wgpu-utils";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "gfx-rs";
    repo = "wgpu";
    rev = "utils-${version}";
    sha256 = "sha256-bOUcLtT5iPZuUgor2d/pJQ4Y+I1LMzREgj1cwLAvd+s=";
  };

  cargoSha256 = "sha256-SSEG8JApQrgP7RWlXqb+xuy482oQZ5frE2IaVMruuG0=";

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
