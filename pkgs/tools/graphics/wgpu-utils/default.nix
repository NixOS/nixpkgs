{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, cmake
, makeWrapper
, vulkan-loader
, freetype
, fontconfig
, QuartzCore
}:

rustPlatform.buildRustPackage rec {
  pname = "wgpu-utils";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "gfx-rs";
    repo = "wgpu";
    rev = "v${version}";
    hash = "sha256-NFn7rCmg37/Vy8owZUNmdH1BQv+bU46bkZl0reMrjWI=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "naga-0.13.0" = "sha256-6GlUj1oIWeBmawdZ/IpC8SN9EJ6RyhA1K441tqN3HAM=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    makeWrapper
  ];

  buildInputs = [ freetype fontconfig ] ++ lib.optional stdenv.isDarwin QuartzCore;

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
