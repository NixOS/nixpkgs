{ lib
, fetchFromGitHub
, rustPlatform
, testers
, nix-update-script
, biscuit-cli
}:

rustPlatform.buildRustPackage rec {
  pname = "biscuit-cli";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "biscuit-auth";
    repo = "biscuit-cli";
    rev = version;
    sha256 = "sha256-BLDJ4Rzu48sAklbv021XSzmATRd+D01yGHqJt6kvjGw=";
  };

  cargoHash = "sha256-J5/3zk9ZjSuiZBKrogP+8sVZr+w9dYlROkRRJFPyVvs=";

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
