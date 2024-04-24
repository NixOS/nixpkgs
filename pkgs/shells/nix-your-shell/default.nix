{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:
rustPlatform.buildRustPackage rec {
  pname = "nix-your-shell";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "MercuryTechnologies";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gjOvAy15y4WJ4LMmiF17nuY6aAsC1V7/zZ+nt+xDh24=";
  };

  cargoHash = "sha256-EyE/Sv8cY/e8uf4b/7M3kJhd/l+dZS62np58xICF77U=";

  meta = with lib; {
    mainProgram = "nix-your-shell";
    description = "A `nix` and `nix-shell` wrapper for shells other than `bash`";
    homepage = "https://github.com/MercuryTechnologies/nix-your-shell";
    license = [ licenses.mit ];
    maintainers = [ maintainers._9999years ];
  };

  passthru.updateScript = nix-update-script { };
}
