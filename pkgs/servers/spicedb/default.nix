{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "spicedb";
  version = "1.42.0";

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "spicedb";
    rev = "v${version}";
    hash = "sha256-7E9wbPi82F9mqqEsnK96a376QRu9NnpdZRAFB0pe1Lc=";
  };

  vendorHash = "sha256-mjzVMtTLJiimzQcXntd2JTIDQS7ndRqosxCVorzcn54=";

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
