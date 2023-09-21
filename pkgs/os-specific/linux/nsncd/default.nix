{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, nix-gitignore
}:

rustPlatform.buildRustPackage rec {
  pname = "nsncd";
  version = "unstable-2022-11-14";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nsncd";
    rev = "47e580f1db99603df6e212a2e62f18cc970cef40";
    hash = "sha256-Nv3MYZcuYgD66BAGs3Tg37s086HAGsaDBFvELqQF3Tk=";
  };

  cargoSha256 = "sha256-c1L6nEUBHw1YegmoRrI3WU/bF80Nzbz13hsGlNyBR9o=";

  meta = with lib; {
    description = "the name service non-caching daemon";
    longDescription = ''
      nsncd is a nscd-compatible daemon that proxies lookups, without caching.
    '';
    homepage = "https://github.com/twosigma/nsncd";
    license = licenses.asl20;
    maintainers = with maintainers; [ flokli ninjatrappeur ];
    # never built on aarch64-darwin, x86_64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin;
  };
}
