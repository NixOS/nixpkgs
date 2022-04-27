{ lib
, fetchFromGitHub
, buildGoModule
, stdenv
}:

buildGoModule rec {
  pname = "oh-my-posh";
  version = "8.29.4";

  src = fetchFromGitHub {
    owner = "JanDeDobbeleer";
    repo = "oh-my-posh";
    rev = "v${version}";
    sha256 = "u6xZJ+XVzAtY9UNqdpKRdeBqo99r1b3Riph/6KzHYaI=";
  };
  modRoot = "./src";
  vendorSha256 = "t4FpvXsGVsTYoGM8wY2JelscnlmDzrLMPYk7zGUfo58=";

  ldflags = [ "-a" "-s" "-w" "-X" "main.Version=${version}" "-extldflags" ''"-static"'' ];

  tags = [ "netgo" "osusergo" "static_build" ];

  postInstall = ''
    mkdir -p $out
    cp -r ${src}/themes $out
  '';

  meta = with lib; {
    description = "A prompt theme engine for any shell";
    homepage = "https://ohmyposh.dev/";
    license = licenses.mit;
    maintainers = with maintainers; [ shrykewindgrace ];
    # it should work on darwin, too, but I do not have the expertise to make it work on nix
    # it has something to do with -lpthread
    broken = stdenv.isDarwin;
  };
}
