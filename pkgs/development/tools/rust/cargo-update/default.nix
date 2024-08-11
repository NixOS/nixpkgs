{ lib
, rustPlatform
, fetchCrate
, cmake
, installShellFiles
, pkg-config
, ronn
, stdenv
, curl
, libgit2
, libssh2
, openssl
, zlib
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-update";
  version = "14.0.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-TSqvT5YjnlfXvNjsiG7lR4f8QIzFoTG9Z70Wy66MhNM=";
  };

  cargoHash = "sha256-hkKr/3mTrnznOWfySTWY+tmeWYjn7nAk+sP4ISPlqHs=";

  nativeBuildInputs = [
    cmake
    installShellFiles
    pkg-config
    ronn
  ] ++ lib.optionals stdenv.isDarwin [
    curl
  ];

  buildInputs = [
    libgit2
    libssh2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    curl
    darwin.apple_sdk.frameworks.Security
  ];

  postBuild = ''
    # Man pages contain non-ASCII, so explicitly set encoding to UTF-8.
    HOME=$TMPDIR \
    RUBYOPT="-E utf-8:utf-8" \
      ronn -r --organization="cargo-update developers" man/*.md
  '';

  postInstall = ''
    installManPage man/*.1
  '';

  env = {
    LIBGIT2_NO_VENDOR = 1;
  };

  meta = with lib; {
    description = "Cargo subcommand for checking and applying updates to installed executables";
    homepage = "https://github.com/nabijaczleweli/cargo-update";
    changelog = "https://github.com/nabijaczleweli/cargo-update/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli Br1ght0ne johntitor matthiasbeyer ];
  };
}
