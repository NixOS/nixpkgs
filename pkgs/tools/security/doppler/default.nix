{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "doppler";
  version = "3.15.0";

  src = fetchFromGitHub {
    owner = "dopplerhq";
    repo = "cli";
    rev = version;
    sha256 = "06icddb99ahmi5djrslpqsjjd38agvkhnfls5wqahclf0j4dylr6";
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
