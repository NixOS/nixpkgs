{ lib, fetchFromGitHub, buildGoModule, updateGolangSysHook }:

buildGoModule rec {
  pname = "mdr";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "MichaelMure";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ibM3303pXnseAFP9qFTOzj0G/SxRPX+UeRfbJ+MCABk=";
  };

  nativeBuildInputs = [ updateGolangSysHook ];

  vendorSha256 = "sha256-PrakjpL7fTU3N/ujLvzEbnjc1yGFIJ6KvowPo+MIoWY=";

  ldflags = [
    "-s"
    "-w"
    "-X main.GitCommit=${src.rev}"
    "-X main.GitLastTag=${version}"
    "-X main.GitExactTag=${version}"
  ];

  meta = with lib; {
    description = "MarkDown Renderer for the terminal";
    homepage = "https://github.com/MichaelMure/mdr";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
