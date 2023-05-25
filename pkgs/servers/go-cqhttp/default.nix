{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "go-cqhttp";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "Mrs4s";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Vc/k4mb1JramT2l+zu9zZQa65gP5XvgqUEQgle1vX8w=";
  };

  vendorSha256 = "sha256-tAvo96hIWxkt3rrrPH5fDKwfwuc76Ze0r55R/ZssU4s=";

  meta = with lib; {
    description = "The Golang implementation of OneBot based on Mirai and MiraiGo";
    homepage = "https://github.com/Mrs4s/go-cqhttp";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ Anillc ];
  };
}
