{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zed";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "zed";
    rev = "v${version}";
    hash = "sha256-Bbh57UQRB/G5r4FoExp+cJyraTM/jBf87Ylt4BgPVdQ=";
  };

  vendorHash = "sha256-AKp7A9WnN9fSGqr4fU53e1/rzBgbV4DJIZKxLms2WDk=";

  meta = with lib; {
    description = "Command line for managing SpiceDB";
    mainProgram = "zed";
    longDescription = ''
      SpiceDB is an open-source permissions database inspired by
      Google Zanzibar. zed is the command line client for SpiceDB.
    '';
    homepage = "https://authzed.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
