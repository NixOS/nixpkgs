{ lib
, fetchFromGitea
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "wgautomesh";
  version = "0.1.0";

  src = fetchFromGitea {
    domain = "git.deuxfleurs.fr";
    owner = "Deuxfleurs";
    repo = "wgautomesh";
    rev = "v${version}";
    sha256 = "FiFEpYLSJg52EtBXaZ685ICbaIyY9URrDt0bS0HPi0Q=";
  };

  cargoHash = "sha256-DGDVjQ4fr4/F1RE0qVc5CWcXrrCEswCF7rQQwlKzMPA=";

  meta = with lib; {
    description = "Simple utility to help connect wireguard nodes together in a full mesh topology";
    homepage = "https://git.deuxfleurs.fr/Deuxfleurs/wgautomesh";
    license = licenses.agpl3Only;
    maintainers = [ maintainers.lx ];
    mainProgram = "wgautomesh";
  };
}
