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
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "tauri-apps";
    repo = pname;
    rev = "tauri-v${version}";
    sha256 = "sha256-Yufj1C1rvjquqRx+t5xin1zna7wtQaKR4T6oRp8kQAc=";
  };

  # Manually specify the sourceRoot since this crate depends on other crates in the workspace. Relevant info at
  # https://discourse.nixos.org/t/difficulty-using-buildrustpackage-with-a-src-containing-multiple-cargo-workspaces/10202
  sourceRoot = "source/tooling/cli";

  cargoSha256 = "sha256-Azx0iFwGXgmANwlLraVU/ojsHBGjiJcM8KsbQPYOXJU=";

  buildInputs = [ glibc libsoup cairo gtk3 webkitgtk ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Build smaller, faster, and more secure desktop applications with a web frontend";
    homepage = "https://tauri.app/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dit7ya ];
  };
}
