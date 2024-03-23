{ lib
, boost
, fetchFromGitHub
, fetchpatch
, libsodium
, nix
, pkg-config
, rustPlatform
, nix-update-script
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "harmonia";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "refs/tags/${pname}-v${version}";
    hash = "sha256-XtnK54HvZMKZGSCrVD0FO5PQLMo3Vkj8ezUlsfqStq0=";
  };

  patches = [
    # Cherry-pick of https://github.com/nix-community/harmonia/pull/293 into 0.7.3
    # We can't bump to 0.7.5 in release-23.11 as it brings a libnixstore bump
    # with backwards-incompatible changes (for a new Nix version).
    (fetchpatch {
      url = "https://github.com/nix-community/harmonia/pull/293/commits/3232511db91b7dce97172a8b018f0056585890f5.patch";
      hash = "sha256-BQ2eJkPTKnwa62dqy6qe7Jq+wJ2Ds5VhT5ST/xVlHiQ=";
    })
  ];

  cargoHash = "sha256-oQVHrfNPhslYk6APB/bhW+h+vk/gNTW/ZypoGGb5zPk=";

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
