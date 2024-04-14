{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, nix-gitignore
}:

rustPlatform.buildRustPackage rec {
  pname = "nsncd";
  version = "unstable-2024-01-16";

  src = fetchFromGitHub {
    owner = "twosigma";
    repo = "nsncd";
    rev =  "f4706786f26d12c533035fb2916be9be5751150b";
    hash = "sha256-GbKDWW00eZZwmslkaGIO8hjCyD5xi7h+S2WP6q5ekOQ=";
  };

  cargoSha256 = "sha256-jAxcyMPDTBFBrG0cuKm0Tm5p/UEnUgTPQKDgqY2yK7w=";
  checkFlags = [
    # Relies on the test environment to be able to resolve "localhost"
    # on IPv4. That's not the case in the Nix sandbox somehow. Works
    # when running cargo test impurely on a (NixOS|Debian) machine.
    "--skip=ffi::test_gethostbyname2_r"
  ];

  meta = with lib; {
    description = "the name service non-caching daemon";
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
