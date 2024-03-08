{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:
rustPlatform.buildRustPackage rec {
  pname = "nix-your-shell";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "MercuryTechnologies";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-pa52demadLi5VN+GixQKVL9iD1kb9c32PqIh86BIUR8=";
  };

  cargoHash = "sha256-btM9AUH1S1AA8gEwXwouOT/E2oio0CmOZ738M+DUMiE=";

  meta = with lib; {
    mainProgram = "nix-your-shell";
    description = "A `nix` and `nix-shell` wrapper for shells other than `bash`";
    homepage = "https://github.com/MercuryTechnologies/nix-your-shell";
    license = [ licenses.mit ];
    maintainers = [ maintainers._9999years ];
  };

  passthru.updateScript = nix-update-script { };
}
