{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "doppler";
  version = "3.40.0";

  src = fetchFromGitHub {
    owner = "dopplerhq";
    repo = "cli";
    rev = version;
    sha256 = "sha256-OnsRVWRPSvU9zj2/Sga9KRiMzqVwtGq1OINmfztNWvU=";
  };

  vendorSha256 = "sha256-Q4NnzKewL9l+tfxeA3ASFanBo2XfqhM++rQjQzRdrAY=";

  ldflags = [ "-X github.com/DopplerHQ/cli/pkg/version.ProgramVersion=v${version}" ];

  postInstall = ''
    mv $out/bin/cli $out/bin/doppler
  '';

  meta = with lib; {
    homepage = "https://doppler.com";
    description = "The official CLI for interacting with your Doppler Enclave secrets and configuation";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
  };
}
