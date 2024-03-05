
{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "spicedb";
  version = "1.29.1";

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "spicedb";
    rev = "v${version}";
    hash = "sha256-fUTJpdFFNf/r+NQYBU4y8sGdtEShF9Yi89aB0rU7Xd8=";
  };

  vendorHash = "sha256-wPQ6RjDldO2m4myKcLtGoe5LurX6FI7yLoWLZUkex4o=";

  subPackages = [ "cmd/spicedb" ];

  meta = with lib; {
    description = "Open source permission database";
    longDescription = ''
      SpiceDB is an open-source permissions database inspired by
      Google Zanzibar.
    '';
    homepage = "https://authzed.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ thoughtpolice ];
    mainProgram = "spicedb";
  };
}
