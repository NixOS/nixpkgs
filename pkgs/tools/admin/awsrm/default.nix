{ lib, buildGoModule, fetchFromGitHub, updateGolangSysHook }:

buildGoModule rec {
  pname = "awsrm";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "jckuester";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KAujqYDtZbCBRO5WK9b9mxqe84ZllbBoO2tLnDH/bdo=";
  };

  nativeBuildInputs = [ updateGolangSysHook ];

  vendorSha256 = "sha256-bEBUEk2LVVEJ2tbtVrZ5siXfPkfyVqGU5aOKCOVZ4V8=";

  ldflags =
    let t = "github.com/jckuester/awsrm/internal";
    in [ "-s" "-w" "-X ${t}.version=${version}" "-X ${t}.commit=${src.rev}" "-X ${t}.date=unknown" ];

  doCheck = false;

  meta = with lib; {
    description = "A remove command for AWS resources";
    homepage = "https://github.com/jckuester/awsrm";
    license = licenses.mit;
    maintainers = [ maintainers.markus1189 ];
  };
}
