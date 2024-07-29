{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, nix-gitignore
}:

rustPlatform.buildRustPackage rec {
  pname = "nsncd";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "twosigma";
    repo = "nsncd";
    rev = "v${version}";
    hash = "sha256-nTXtIZ/2SBpViCTk3fcv4mUAPjc+DRSEUjSVdNt04A8=";
  };

  cargoHash = "sha256-S2kshoM9jEgMLcCTydmQN5DM/sGAv2ENPAAFlaGCedI=";
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
