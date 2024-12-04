
{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "spicedb";
  version = "1.37.1";

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "spicedb";
    rev = "v${version}";
    hash = "sha256-15X9Q6akidXTYO5U3MYi14u8shTicQQ9wGSVOcefxhg=";
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
