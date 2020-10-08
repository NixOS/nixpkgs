{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "doppler";
  version = "3.10.3";

  src = fetchFromGitHub {
    owner = "dopplerhq";
    repo = "cli";
    rev = version;
    sha256 = "15wmg67wwwgrs8q45r1z98k9v7mf2bfgsa40gcf8dr18ilnfpbn4";
  };

  vendorSha256 = "0wqbwk72k4r30a3vnf0gnx3k97y8xgnr2iavk5bc8f8vkjv0bsv6";

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
