{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "go-cqhttp";
  version = "1.0.0-rc5";

  src = fetchFromGitHub {
    owner = "Mrs4s";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-t9R1hnd0LzLYn2EiX6JOpbVuhyrWJUB0FYikP2g1CYs=";
  };

  vendorSha256 = "sha256-4j1CRRaHzjvFus+djR9tJU4vVY4g34o8V1owz7hi4qI=";

  meta = with lib; {
    description = "The Golang implementation of OneBot based on Mirai and MiraiGo";
    homepage = "https://github.com/Mrs4s/go-cqhttp";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ Anillc ];
  };
}
