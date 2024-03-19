{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zed";
  version = "0.16.4";

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "zed";
    rev = "v${version}";
    hash = "sha256-PLOzzsW0v4T12NFrQlOYcsC7Cd3OnGD0TYmuavqEtxw=";
  };

  vendorHash = "sha256-KhtT0v0FJiOvYUhN/rBYxbkUKs0DdIc5HwlhVUAi9cA=";

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
