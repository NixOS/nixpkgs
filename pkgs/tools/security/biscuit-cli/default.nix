{ lib
, fetchFromGitHub
, rustPlatform
, testers
, nix-update-script
, biscuit-cli
}:

rustPlatform.buildRustPackage rec {
  pname = "biscuit-cli";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "biscuit-auth";
    repo = "biscuit-cli";
    rev = version;
    sha256 = "sha256-Aj/s5RnkRFZMOJAHY9tdVtq24DgrgMjaYEq7oA9lXFc=";
  };

  cargoHash = "sha256-TUu+2i+GJiS7PvzVDwWLa+w+RfbYX+k51WG2LbcqINk=";

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
