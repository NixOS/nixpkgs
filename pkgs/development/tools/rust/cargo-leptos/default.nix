{ stdenv, rustPlatform , fetchFromGitHub, Security, lib, pkg-config, openssl }:
rustPlatform.buildRustPackage rec {
  pname = "cargo-leptos";
  version = "0.1.8";
  buildFeatures = [ "no_downloads" ]; # cargo-leptos will try to download Ruby and other things without this feature

  src = fetchFromGitHub {
    owner = "leptos-rs";
    repo = pname;
    rev = version;
    hash = "sha256-z4AqxvKu9E8GGMj6jNUAAWeqoE/j+6NoAEZWeNZ+1BA=";
  };

  cargoSha256 = "sha256-w/9W4DXbh4G5DZ8IGUz4nN3LEjHhL7HgybHqODMFzHw=";

  nativeBuildInputs = [ pkg-config openssl ];

  buildInputs = [ openssl pkg-config ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  doCheck = false; # integration tests depend on changing cargo config

  meta = with lib; {
    description = "A build tool for the Leptos web framework";
    homepage = "https://github.com/leptos-rs/cargo-leptos";
    changelog = "https://github.com/leptos-rs/cargo-leptos/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ benwis ];
  };
}
