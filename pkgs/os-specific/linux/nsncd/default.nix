{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage {
  pname = "nsncd";
  version = "1.4.1-unstable-2024-10-03";

  src = fetchFromGitHub {
    owner = "twosigma";
    repo = "nsncd";
    rev = "cf94e3cfc7dfff69867209c7e68945bac2d3913d";
    hash = "sha256-mjTbyO0b9i4LMv7DWHm0Y4z1pvcapCtFsHLV5cTAxQE=";
  };

  cargoHash = "sha256-cgdob/HmE6I59W5UQRItAFXDj7IvazNt99LbJlKQDNo=";

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

  passthru = {
    tests.nscd = nixosTests.nscd;
    updateScript = nix-update-script { };
  };
}
