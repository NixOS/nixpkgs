{ pkgs
, lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "docker-compose-wait";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "ufoscout";
    repo = pname;
    rev = version;
    sha256 = "141m8ll9fm3863fgp8pcy8sgv5ills9kskzb3ymdi1ppwdq2hzhm";
  };

  cargoSha256 = "000kb8ahkzbr2w60rsx3qchdjhkiy9g44c9b9qjq3krqi242fqp6";

  meta = with lib; {
    description = "A small command-line utility to wait for other docker images to be started while using docker-compose.";
    homepage = "https://github.com/ufoscout/docker-compose-wait";
    license = licenses.asl20;
    maintainers = [ maintainers.tristanpemble ];
  };
}
