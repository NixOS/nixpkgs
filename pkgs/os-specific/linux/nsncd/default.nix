{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, nix-gitignore
}:

rustPlatform.buildRustPackage rec {
  pname = "nsncd";
  version = "unstable-2024-03-18";

  src = fetchFromGitHub {
    owner = "twosigma";
    repo = "nsncd";
    rev =  "7605e330d5a313a8656e6fcaf1c10cd6b5cdd427";
    hash = "sha256-Bd7qE9MP5coBCkr70TdoJfwYhQpdrn/zmN4KoARcaMI=";
  };

  cargoHash = "sha256-i1rmc5wxtc631hZy2oM4d6r7od0w8GrG7+/pdM6Gqco=";
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
    maintainers = with maintainers; [ flokli picnoir ];
    # never built on aarch64-darwin, x86_64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin;
  };
}
