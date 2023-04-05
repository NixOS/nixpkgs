{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "gir";
  version = "unstable-2021-11-21";

  src = fetchFromGitHub {
    owner = "gtk-rs";
    repo = "gir";
    rev = "a69abbe5ee1a745e554cac9433c65d2ac26a7688";
    sha256 = "16ygy1bcbcj69x6ss72g9n62qlsd1bacr5hz91f8whw6qm9am46m";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rustdoc-stripper-0.1.18" = "sha256-eQxAS76kV01whXK21PN5U+nkpvpn6r4VOoe9/pkuAQY=";
    };
  };

  postPatch = ''
    rm build.rs
    sed -i '/build = "build\.rs"/d' Cargo.toml
    echo "pub const VERSION: &str = \"$version\";" > src/gir_version.rs
  '';

  meta = with lib; {
    description = "Tool to generate rust bindings and user API for glib-based libraries";
    homepage = "https://github.com/gtk-rs/gir/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ekleog ];
    mainProgram = "gir";
  };
}
