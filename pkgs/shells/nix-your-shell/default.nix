{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:
rustPlatform.buildRustPackage rec {
  pname = "nix-your-shell";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "MercuryTechnologies";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-pBryTpCFwOkK5astzpYzhj/fJ9QS7IiKUck/Y4gLZZw=";
  };

  cargoHash = "sha256-6A7Lvys22dnFMKm1uRo2CCZk9LBRqHPBnmRPbvbDryI=";

  meta = with lib; {
    mainProgram = "nix-your-shell";
    description = "A `nix` and `nix-shell` wrapper for shells other than `bash`";
    homepage = "https://github.com/MercuryTechnologies/nix-your-shell";
    license = [ licenses.mit ];
    maintainers = [ maintainers._9999years ];
  };

  passthru.updateScript = nix-update-script { };
}
