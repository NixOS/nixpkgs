{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, glibc
, libsoup
, cairo
, gtk3
, webkitgtk
}:

rustPlatform.buildRustPackage rec {
  pname = "tauri";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "tauri-apps";
    repo = pname;
    rev = "tauri-v${version}";
    sha256 = "sha256-RBaIF9vWQwQAdqN3p3JS1WO6u3IMxi8CuCkrwQbd2gI=";
  };

  # Manually specify the sourceRoot since this crate depends on other crates in the workspace. Relevant info at
  # https://discourse.nixos.org/t/difficulty-using-buildrustpackage-with-a-src-containing-multiple-cargo-workspaces/10202
  sourceRoot = "source/tooling/cli";

  cargoSha256 = "sha256-8sdCVOtPwIjW2x1yh1B0oybVi2kz3LQoK3OcaJvUsxQ=";

  buildInputs = [ glibc libsoup cairo gtk3 webkitgtk ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Build smaller, faster, and more secure desktop applications with a web frontend";
    homepage = "https://tauri.app/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dit7ya ];
  };
}
