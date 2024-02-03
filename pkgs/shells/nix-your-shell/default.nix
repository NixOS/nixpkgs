{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:
rustPlatform.buildRustPackage rec {
  pname = "nix-your-shell";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "MercuryTechnologies";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5zHjz0NOKcZCuR6QaLrwOXih3Xoqf2uBrJnxTX/TQok=";
  };

  cargoSha256 = "sha256-4Z/z4VgnJQd8Uc0tMDnx7sChzXtG5ZDL88jTlhPSonM=";

  meta = with lib; {
    mainProgram = "nix-your-shell";
    description = "A `nix` and `nix-shell` wrapper for shells other than `bash`";
    homepage = "https://github.com/MercuryTechnologies/nix-your-shell";
    license = [ licenses.mit ];
    maintainers = [ maintainers._9999years ];
  };

  passthru.updateScript = nix-update-script { };
}
