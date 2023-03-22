{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, makeWrapper, vulkan-loader, QuartzCore }:

rustPlatform.buildRustPackage rec {
  pname = "wgpu-utils";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "gfx-rs";
    repo = "wgpu";
    rev = "v${version}";
    hash = "sha256-U2e7uOGaVpT/c9EXubkaKkROjog073hVfot2bbB34AY=";
  };

  cargoHash = "sha256-QMw3jTZ5XmX9VBe5uiD7yoUIkWGqZcE1pOS6ljZ5qd0=";

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
