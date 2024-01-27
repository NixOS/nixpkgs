{ lib
, rustPlatform
, fetchCrate
, cmake
, installShellFiles
, pkg-config
, ronn
, stdenv
, curl
, libgit2_1_5
, libssh2
, openssl
, zlib
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-update";
  version = "13.3.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-owiMVeH7m4LoM8c4qjLyFx3v/+Flzt+C+O8qEuXazvc=";
  };

  cargoHash = "sha256-WtNH62DBo6WFOUcHnZxn0Jco4SUmhO0+1wXPRB2wxic=";

  nativeBuildInputs = [
    cmake
    installShellFiles
    pkg-config
    ronn
  ] ++ lib.optionals stdenv.isDarwin [
    curl
  ];

  buildInputs = [
    libgit2_1_5
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

  meta = with lib; {
    description = "A cargo subcommand for checking and applying updates to installed executables";
    homepage = "https://github.com/nabijaczleweli/cargo-update";
    changelog = "https://github.com/nabijaczleweli/cargo-update/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli Br1ght0ne johntitor matthiasbeyer ];
  };
}
