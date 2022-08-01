{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "doppler";
  version = "3.40.1";

  src = fetchFromGitHub {
    owner = "dopplerhq";
    repo = "cli";
    rev = version;
    sha256 = "sha256-OVfclCkyFw9GO7sGjId40vrmnt4oyHjNYZBNFjyYFUc=";
  };

  vendorSha256 = "sha256-evG1M0ZHfn9hsMsSncwxF5Hr/VJ7y6Ir0D2gHJaunBo=";

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
