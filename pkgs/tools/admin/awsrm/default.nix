{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "awsrm";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "jckuester";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KAujqYDtZbCBRO5WK9b9mxqe84ZllbBoO2tLnDH/bdo=";
  };

  vendorHash = "sha256-CldEAeiFH7gdFNLbIe/oTzs8Pdnde7EqLr7vP7SMDGU=";

  ldflags =
    let
      t = "github.com/jckuester/awsrm/internal";
    in
    [
      "-s"
      "-w"
      "-X ${t}.version=${version}"
      "-X ${t}.commit=${src.rev}"
      "-X ${t}.date=unknown"
    ];

  doCheck = false;

  meta = with lib; {
    description = "A remove command for AWS resources";
    homepage = "https://github.com/jckuester/awsrm";
    license = licenses.mit;
    maintainers = [ maintainers.markus1189 ];
    mainProgram = "awsrm";
  };
}
