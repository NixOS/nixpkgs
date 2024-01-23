
{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "spicedb";
  version = "1.29.0";

  src = fetchFromGitHub {
    owner = "authzed";
    repo = "spicedb";
    rev = "v${version}";
    hash = "sha256-AQmYoTrCwS2IdA9N2RWmbnPNIfKW3ofreZv+VEbe1Wg=";
  };

  vendorHash = "sha256-LYVxKrFMtxG13cxpQ2btXO9EmKY0UBI+ZP3aYI88i3A=";

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
