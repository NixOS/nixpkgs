{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, nix-gitignore
}:

rustPlatform.buildRustPackage rec {
  pname = "nsncd";
  version = "unstable-2023-10-26";

  # https://github.com/twosigma/nsncd/pull/71 has not been upstreamed
  # to twosigma/nsncd yet. Using the nix-community fork in the
  # meantime.
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nsncd";
    rev =  "d6513421f420e407248c6d0aee39ae2f861a7cec";
    hash = "sha256-PykzwpPxMDHJOr2HubXuw+Krk9Jbi0E3M2lEAOXhx2M=";
  };

  cargoSha256 = "sha256-cUM7rYXWpJ0aMiurXBp15IlxAmf/x5uiodxEqBPCQT0=";

  meta = with lib; {
    description = "the name service non-caching daemon";
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
