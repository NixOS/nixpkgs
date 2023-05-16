{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:
rustPlatform.buildRustPackage rec {
  pname = "nix-your-shell";
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "1.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "MercuryTechnologies";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-5zHjz0NOKcZCuR6QaLrwOXih3Xoqf2uBrJnxTX/TQok=";
  };

  cargoSha256 = "sha256-4Z/z4VgnJQd8Uc0tMDnx7sChzXtG5ZDL88jTlhPSonM=";
=======
    sha256 = "sha256-g5TC+4DGbTAlG39R8QIM5cB3/mtkp/vz8puB0Kr6aag=";
  };

  cargoSha256 = "sha256-AiWKSWwMh6KWCTTRRCBxekv2rukz+ijnRit11K/AnhU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A `nix` and `nix-shell` wrapper for shells other than `bash`";
    homepage = "https://github.com/MercuryTechnologies/nix-your-shell";
    license = [ licenses.mit ];
    maintainers = [ maintainers._9999years ];
  };

  passthru.updateScript = nix-update-script { };
}
