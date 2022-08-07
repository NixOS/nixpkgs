{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "natscli";
  version = "0.0.33";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-x1alZ+184dXXL2GeDSnvRjTW5P6GlJCrWL50663/pDo=";
  };

  vendorSha256 = "sha256-f5ozwXpryB7+alJ/ydfpZowJGowcOn6dOHK9pmUSf5c=";

  meta = with lib; {
    description = "NATS Command Line Interface";
    homepage = "https://github.com/nats-io/natscli";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "nats";
  };
}
