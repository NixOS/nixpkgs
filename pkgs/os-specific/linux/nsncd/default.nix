{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "nsncd";
  version = "1.4.1-unstable-2024-04-10";

  src = fetchFromGitHub {
    owner = "twosigma";
    repo = "nsncd";
    rev = "7605e330d5a313a8656e6fcaf1c10cd6b5cdd427";
    hash = "sha256-Bd7qE9MP5coBCkr70TdoJfwYhQpdrn/zmN4KoARcaMI=";
  };

  cargoHash = "sha256-N7U9YsyGh8+fLT973GGZTmVXcdnWhpqkeYTxzJ0rzdo=";

  # TOREMOVE when https://github.com/twosigma/nsncd/pull/119 gets merged.
  cargoPatches = [ ./0001-cargo-bump.patch ];

  # TOREMOVE when https://github.com/twosigma/nsncd/pull/119 gets merged.
  RUSTFLAGS = "-A dead_code";

  checkFlags = [
    # Relies on the test environment to be able to resolve "localhost"
    # on IPv4. That's not the case in the Nix sandbox somehow. Works
    # when running cargo test impurely on a (NixOS|Debian) machine.
    "--skip=ffi::test_gethostbyname2_r"
  ];

  meta = with lib; {
    description = "Name service non-caching daemon";
    mainProgram = "nsncd";
    longDescription = ''
      nsncd is a nscd-compatible daemon that proxies lookups, without caching.
    '';
    homepage = "https://github.com/twosigma/nsncd";
    license = licenses.asl20;
    maintainers = with maintainers; [
      flokli
      picnoir
    ];
    # never built on aarch64-darwin, x86_64-darwin since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isDarwin;
  };
}
