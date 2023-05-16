{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "errcheck";
<<<<<<< HEAD
  version = "1.6.3";
=======
  version = "unstable-2022-03-26";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kisielk";
    repo = "errcheck";
<<<<<<< HEAD
    rev = "v${version}";
    hash = "sha256-t5ValY4I3RzsomJP7mJjJSN9wU1HLQrajxpqmrri/oU=";
  };

  vendorHash = "sha256-96+927gNuUMovR4Ru/8BwsgEByNq2EPX7wXWS7+kSL8=";
=======
    rev = "e62617a91f7bd1abab2cbe7f28966188dd85eee0";
    sha256 = "sha256-RoPv6Odh8l9DF1S50pNEomLtI4uTDNjveOXZd4S52c0=";
  };

  vendorSha256 = "sha256-fDugaI9Fh0L27yKSFNXyjYLMMDe6CRgE6kVLiJ3+Kyw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  meta = with lib; {
    description = "Checks for unchecked errors in go programs";
    homepage = "https://github.com/kisielk/errcheck";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
