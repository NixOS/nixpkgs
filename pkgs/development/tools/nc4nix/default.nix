{ lib
, buildGoModule
, fetchFromGitLab
}:

buildGoModule rec {
  pname = "nc4nix";
  version = "unstable-2022-11-12";

  src = fetchFromGitLab {
    domain = "git.project-insanity.org";
    owner = "onny";
    repo = "nc4nix";
    rev = "d7f55a42b5ca0d02382349c6ec776eefe6079703";
    sha256 = "sha256-MfMW2B+udXV/lQPGUBFuAE7jwmy4D1M+CYkCuJ088aM=";
  };

  vendorSha256 = "sha256-uhINWxFny/OY7M2vV3ehFzP90J6Z8cn5IZHWOuEg91M=";

  meta = with lib; {
    description = "Packaging helper for Nextcloud apps";
    homepage = "https://git.project-insanity.org/onny/nc4nix";
    license = licenses.unfree;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.linux;
  };
}

