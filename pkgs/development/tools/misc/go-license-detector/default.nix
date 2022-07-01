{ lib, buildGoModule, fetchFromGitHub, git }:

buildGoModule rec {
  pname = "go-license-detector";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "go-enry";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MubQpxpUCPDBVsEz4NmY8MFEoECXQtzAaZJ89vv5bDc=";
  };

  vendorSha256 = "sha256-a9yCnGg+4f+UoHbGG8a47z2duBD3qXcAzPKnE4PQsvM=";

  checkInputs = [ git ];

  meta = with lib; {
    description = "Reliable project licenses detector";
    homepage = "https://github.com/go-enry/go-license-detector";
    license = licenses.asl20;
    maintainers = with maintainers; [ dtzWill ];
    mainProgram = "license-detector";
  };
}
