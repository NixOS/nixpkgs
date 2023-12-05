{ lib
, fetchFromGitHub
, rustPlatform
, testers
, nix-update-script
, biscuit-cli
}:

rustPlatform.buildRustPackage rec {
  pname = "biscuit-cli";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "biscuit-auth";
    repo = "biscuit-cli";
    rev = version;
    sha256 = "sha256-Mvrv3BU0Pw85fs8IbjMKSQLIhtU6SKoLC0cuGdhfAYs=";
  };

  cargoHash = "sha256-tgmM0rswIFrpFyupaASTXYvIyhVu0fXJJN+hg0p+vrQ=";

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
