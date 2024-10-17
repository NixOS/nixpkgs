
{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "spicedb";
  version = "1.37.0";

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "spicedb";
    rev = "v${version}";
    hash = "sha256-ClBT0S5pb/XRQftvbnwqGJE6SBuGQCvb/A8oY/tv0/c=";
  };

  vendorHash = "sha256-aTfjSGen9rJ/GTCUFuuEykNqQNsnuNyRGm7CtMSZoJ0=";

  ldflags = [
    "-X 'github.com/jzelinskie/cobrautil/v2.Version=${src.rev}'"
  ];

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
