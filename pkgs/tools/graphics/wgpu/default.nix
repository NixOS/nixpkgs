{ lib, rustPlatform, fetchFromGitHub, pkg-config, makeWrapper, vulkan-loader }:

rustPlatform.buildRustPackage rec {
  pname = "wgpu";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "gfx-rs";
    repo = pname;
    rev = "9da5c1d3a026c275feb57606b8c8d61f82b43386";
    sha256 = "sha256-DcIMP06tlMxI16jqpKqei32FY8h7z41Nvygap2MQC8A=";
  };

  cargoSha256 = "sha256-3gtIx337IP5t4nYGysOaU7SZRJrvVjYXN7mAqGbVlo8=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

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
