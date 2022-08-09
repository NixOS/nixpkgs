{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "railway";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-0849Rm1QSMAJ2jVK0H8sA89bxI2nFDDTEsnSdXTuWTs=";
  };

  ldflags = [ "-s" "-w" ];

  vendorSha256 = "sha256-nLuomuAScodgLUKzMTiygtFBnNHrqAojOySZgKLVGJY=";

  postInstall = ''
    mv $out/bin/cli $out/bin/railway
  '';

  meta = with lib; {
    description = "Railway CLI";
    homepage = "https://railway.app";
    license = licenses.mit;
    maintainers = with maintainers; [ Crafter ];
  };
}
