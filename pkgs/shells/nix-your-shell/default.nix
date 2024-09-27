{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:
rustPlatform.buildRustPackage rec {
  pname = "nix-your-shell";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "MercuryTechnologies";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FjGjLq/4qeZz9foA7pfz1hiXvsdmbnzB3BpiTESLE1c=";
  };

  cargoHash = "sha256-2NgN2/dr48ogkcjOq6UE4jDQBeewceWzdpRlXqi744s=";

  meta = with lib; {
    mainProgram = "nix-your-shell";
    description = "`nix` and `nix-shell` wrapper for shells other than `bash`";
    homepage = "https://github.com/MercuryTechnologies/nix-your-shell";
    license = [ licenses.mit ];
    maintainers = [ maintainers._9999years ];
  };

  passthru.updateScript = nix-update-script { };
}
