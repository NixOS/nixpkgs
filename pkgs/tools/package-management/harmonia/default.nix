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
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "refs/tags/${pname}-v${version}";
    hash = "sha256-mMwKth54SCy7Acuhf4D04XP070Zf1mzCR+s7cvpsnQE=";
  };

  cargoHash = "sha256-XwfSTaw98xB6bRFIBS4FmLp7aoEGKAbKzbWS32l5C9Y=";

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
