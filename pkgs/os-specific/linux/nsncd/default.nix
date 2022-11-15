{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, nix-gitignore
}:

rustPlatform.buildRustPackage rec {
  pname = "nsncd";
  version = "unstable-2021-10-20";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nsncd";
    rev = "b9425070bb308565a6e4dc5aefd568952a07a4ed";
    hash = "sha256-ZjInzPJo+PWAM2gAKhlasLXiqo+2Df4DIXpNwtqQVc8=";
  };

  cargoSha256 = "sha256-hxdI+HHB0PB/zDMI21Pg5Xr9mTDn4T+OcAAenUox4bs=";

  meta = with lib; {
    description = "the name service non-caching daemon";
    longDescription = ''
      nsncd is a nscd-compatible daemon that proxies lookups, without caching.
    '';
    homepage = "https://github.com/twosigma/nsncd";
    license = licenses.asl20;
    maintainers = with maintainers; [ flokli ninjatrappeur ];
  };
}
