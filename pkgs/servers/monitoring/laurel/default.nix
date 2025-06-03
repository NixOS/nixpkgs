{
  acl,
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "laurel";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "threathunters-io";
    repo = "laurel";
    tag = "v${version}";
    hash = "sha256-rOf7UtkMoYpReZr/2135QcpMEfYD80IY4zF0TwAWr4I=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Pfs4Bg6VZIiiXQu0ZKcDi9zeEYl08kOnWi3R2iaQG24=";

  postPatch = ''
    # Upstream started to redirect aarch64-unknown-linux-gnu to aarch64-linux-gnu-gcc
    # for their CI which breaks compiling on aarch64 in nixpkgs:
    #  error: linker `aarch64-linux-gnu-gcc` not found
    rm .cargo/config.toml
  '';

  nativeBuildInputs = [ rustPlatform.bindgenHook ];
  buildInputs = [ acl ];

  checkFlags = [
    # Nix' build sandbox does not allow setting ACLs:
    # https://github.com/NixOS/nix/blob/2.28.3/src/libstore/unix/build/local-derivation-goal.cc#L1760-L1769
    # Skip the tests that are failing with "Operation not supported (os error 95)" because of this:
    "--skip=rotate::test::existing"
    "--skip=rotate::test::fresh_file"
  ];

  meta = with lib; {
    description = "Transform Linux Audit logs for SIEM usage";
    homepage = "https://github.com/threathunters-io/laurel";
    changelog = "https://github.com/threathunters-io/laurel/releases/tag/${src.tag}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ emilylange ];
    platforms = platforms.linux;
  };
}
