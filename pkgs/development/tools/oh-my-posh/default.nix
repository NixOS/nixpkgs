{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "oh-my-posh";
  version = "8.37.1";

  src = fetchFromGitHub {
    owner = "jandedobbeleer";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZiDrG1GkUple+Q+MoNQlHdbq3P8PeQFWvxMC9dh7VTM=";
  };

  vendorSha256 = "sha256-t4FpvXsGVsTYoGM8wY2JelscnlmDzrLMPYk7zGUfo58=";

  sourceRoot = "source/src";

  ldflags = [ "-s" "-w" "-X" "main.Version=${version}" ];

  meta = with lib; {
    description = "A prompt theme engine for any shell";
    homepage = "https://ohmyposh.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
