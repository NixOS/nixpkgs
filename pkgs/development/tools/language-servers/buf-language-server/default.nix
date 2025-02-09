{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "buf-language-server";
  version = "unstable-2022-08-19";

  src = fetchFromGitHub {
    owner = "bufbuild";
    repo = pname;
    rev = "6f08a7eed22c5a178cb55613f454319e09be112c";
    sha256 = "sha256-UHsWrWDOC/f3YS2g533CgUkuUmz4MUQRunClQiY/YPQ=";
  };

  vendorHash = "sha256-ORzCOmBx6k1GZj6pYLhqPsdneCc7Tt1yHpI5mw5ruFU=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Language server for protocol buffers";
    homepage = "https://github.com/bufbuild/buf-language-server";
    license = licenses.asl20;
    maintainers = with maintainers; [ svrana ];
  };
}
