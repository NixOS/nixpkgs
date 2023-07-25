{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "agebox";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "slok";
    repo = pname;
    rev = "v${version}";
    sha256 = "1gi6lj3dpckhsx6hdpdnr8rclqgfkbdmkzx966nlxyi52bjfzbsv";
  };
  vendorSha256 = "1jwzx6hp04y8hfpwfvf9zmhqjj3ghvr3gmgnllpcff1lai78vdrw";

  ldflags = [
    "-s" "-w"
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/slok/agebox";
    changelog = "https://github.com/slok/agebox/releases/tag/v${version}";
    description = "Age based repository file encryption gitops tool";
    license = licenses.asl20;
    maintainers = with maintainers; [ lesuisse ];
  };
}
