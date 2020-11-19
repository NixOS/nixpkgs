{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "doppler";
  version = "3.16.1";

  src = fetchFromGitHub {
    owner = "dopplerhq";
    repo = "cli";
    rev = version;
    sha256 = "141ic9vgkqv3hdcpj1dlb4lawzd2rm7h2np21x28mmsd0hlg6v7y";
  };

  vendorSha256 = "1s8zwjfk9kcddn8cywr7llh9v5m140kvmi5lmy2glvwh3rwccgxf";

  buildFlagsArray = "-ldflags=-X github.com/DopplerHQ/cli/pkg/version.ProgramVersion=v${version}";

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
