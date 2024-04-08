{ lib
, boost
, fetchFromGitHub
, libsodium
, nixVersions
, pkg-config
, rustPlatform
, stdenv
, nix-update-script
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "harmonia";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "refs/tags/${pname}-v${version}";
    hash = "sha256-QqRq5maYk4hDl0MXkj9wOPWUta5b+kXG9e/kqRorNE4=";
  };

  cargoHash = "sha256-dlmSn4cWU6RqEiUoQYNJFhxu3owplkxlbtszBxm+GbU=";

  nativeBuildInputs = [
    pkg-config nixVersions.nix_2_21
  ];

  buildInputs = [
    boost
    libsodium
    nixVersions.nix_2_21
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
