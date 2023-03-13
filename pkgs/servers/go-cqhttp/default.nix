{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "go-cqhttp";
  version = "1.0.0-rc4";

  src = fetchFromGitHub {
    owner = "Mrs4s";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7TWKd0y8yBi2piKBCUZFeo3swtC/SteRtXXRv7Ojajs=";
  };

  vendorSha256 = "sha256-Oz/4bazhNnkf26YJ4H7c7d7vNzIJxG2OG0BJOiHBY7Y=";

  meta = with lib; {
    description = "The Golang implementation of OneBot based on Mirai and MiraiGo";
    homepage = "https://github.com/Mrs4s/go-cqhttp";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ Anillc ];
  };
}
