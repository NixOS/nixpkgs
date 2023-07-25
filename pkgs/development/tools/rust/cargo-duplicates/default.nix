{ lib
, rustPlatform
, fetchFromGitHub
, curl
, pkg-config
, libgit2
, openssl
, zlib
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-duplicates";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "Keruspe";
    repo = "cargo-duplicates";
    rev = "v${version}";
    hash = "sha256-e0cegK4obUVIJyx5XKF+xicvkRvQwuObwB8tprrJnrw=";
  };

  cargoHash = "sha256-i1IyHCa/w4DOGlPWjDE4IbVm3s/40DIwjwUGIMTYH4Y=";

  nativeBuildInputs = [
    curl
    pkg-config
  ];

  buildInputs = [
    curl
    libgit2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "A cargo subcommand for displaying when different versions of a same dependency are pulled in";
    homepage = "https://github.com/Keruspe/cargo-duplicates";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
