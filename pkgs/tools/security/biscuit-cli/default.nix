{ lib
, fetchFromGitHub
, rustPlatform
, testers
, nix-update-script
, biscuit-cli
}:

rustPlatform.buildRustPackage rec {
  pname = "biscuit-cli";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "biscuit-auth";
    repo = "biscuit-cli";
    rev = version;
    sha256 = "sha256-Fd5wBvQe7S/UZ42FMlU+f9qTwcLIMnQrCWVRoHxOx64=";
  };

  cargoHash = "sha256-SHRqdKRAHkWK/pEVFYo3d+r761K4j9BkTg2angQOubk=";

  # Version option does not report the correct version
  # https://github.com/biscuit-auth/biscuit-cli/issues/44
  patches = [ ./version-0.4.0.patch ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      inherit version;
      package = biscuit-cli;
      command = "biscuit --version";
    };
  };

  meta = with lib; {
    description = "CLI to generate and inspect biscuit tokens";
    homepage = "https://www.biscuitsec.org/";
    maintainers = with maintainers; [ shlevy gaelreyrol ];
    license = licenses.bsd3;
    mainProgram = "biscuit";
  };
}
