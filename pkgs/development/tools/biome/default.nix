{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, rust-jemalloc-sys
, zlib
, stdenv
, darwin
, git
}:

rustPlatform.buildRustPackage rec {
  pname = "biome";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "biomejs";
    repo = "biome";
    rev = "cli/v${version}";
    hash = "sha256-DooUOp+fr5oOrx04SLlTGro8xc2LieVPNtdvDyTLL/s=";
  };

  cargoHash = "sha256-zMMfLDhiqG8Ahe+7PFjpOtwaBXbKkLDIIoHS329/4uQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    rust-jemalloc-sys
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  nativeCheckInputs = [
    git
  ];

  cargoBuildFlags = [ "-p=biome_cli" ];
  cargoTestFlags = cargoBuildFlags ++
    # skip a broken test from v1.6.3 release
    # this will be removed on the next version
    [ "-- --skip=diagnostics::test::termination_diagnostic_size" ];

  env = {
    BIOME_VERSION = version;
    LIBGIT2_NO_VENDOR = 1;
  };

  preCheck = ''
    # tests assume git repository
    git init

    # tests assume $BIOME_VERSION is unset
    unset BIOME_VERSION
  '';

  meta = with lib; {
    description = "Toolchain of the web";
    homepage = "https://biomejs.dev/";
    changelog = "https://github.com/biomejs/biome/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "biome";
  };
}
