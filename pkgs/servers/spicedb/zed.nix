{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "zed";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "zed";
    rev = "v${version}";
    hash = "sha256-MvqhYRI9FNdgSZTuISisZl+rvQIxoycHsxKPPI0/moo=";
  };

  vendorHash = "sha256-6QZYdWj3ZD6RG3zyPf1AGiBqLVbkXq4NAvR8n3EcYTc=";

  ldflags = [
    "-X 'github.com/jzelinskie/cobrautil/v2.Version=${src.rev}'"
  ];

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
