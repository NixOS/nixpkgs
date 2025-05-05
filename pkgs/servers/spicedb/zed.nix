{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "zed";
  version = "0.30.2";

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "zed";
    rev = "v${version}";
    hash = "sha256-ftSgp0zxUmSTJ7lFHxFdebKrCKbsRocDkfabVpyQ5Kg=";
  };

  vendorHash = "sha256-2AkknaufRhv79c9WQtcW5oSwMptkR+FB+1/OJazyGSM=";

  ldflags = [ "-X 'github.com/jzelinskie/cobrautil/v2.Version=${src.rev}'" ];

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
