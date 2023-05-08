{ lib
, boost
, fetchFromGitHub
, libsodium
, nix
, pkg-config
, rustPlatform
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "harmonia";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "refs/tags/${pname}-v${version}";
    hash = "sha256-erBmPXMyIYxRLbYG35vH67MypJoXomUEFOVu6IhmEWs=";
  };

  cargoHash = "sha256-Gq7U+Uy3psuPVY0wGM90KA5u5Wc2s4hVJma7B11Ag5g=";

  nativeBuildInputs = [
    pkg-config nix
  ];

  buildInputs = [
    boost
    libsodium
    nix
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex" "harmonia-v(.*)" ];
    };
  };

  meta = with lib; {
    description = "Nix binary cache";
    homepage = "https://github.com/helsinki-systems/harmonia";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
