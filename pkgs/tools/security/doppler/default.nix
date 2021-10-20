{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "doppler";
  version = "3.31.1";

  src = fetchFromGitHub {
    owner = "dopplerhq";
    repo = "cli";
    rev = version;
    sha256 = "sha256-m8dugkZ0n51RnclZwKGgjVG3OrDMz3MsOQMvNbG4BPU=";
  };

  vendorSha256 = "sha256-yb7L4GSKtlwagwdxBMd5aSk9fre1NKKsy6CM4Iv2ya8=";

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
