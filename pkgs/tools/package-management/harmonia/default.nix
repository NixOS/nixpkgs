{ lib
, boost
, fetchFromGitHub
, libsodium
, nix
, pkg-config
, rustPlatform
, nix-update-script
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "harmonia";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "refs/tags/${pname}-v${version}";
    hash = "sha256-g4ebmMmH+1DZwqGFNGe2cepHRoJfWtdjDEbQxtnORJI=";
  };

  cargoHash = "sha256-Zg5nvx/bBqj1OrG1X+/2pdLK7ITgiEEEa/hYQUqw3NU=";

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
    tests = { inherit (nixosTests) harmonia; };
  };

  meta = with lib; {
    description = "Nix binary cache";
    homepage = "https://github.com/nix-community/harmonia";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    mainProgram = "harmonia";
  };
}
