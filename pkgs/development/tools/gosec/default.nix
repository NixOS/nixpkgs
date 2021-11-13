{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gosec";
  version = "2.9.1";

  subPackages = [ "cmd/gosec" ];

  src = fetchFromGitHub {
    owner = "securego";
    repo = pname;
    rev = "v${version}";
    sha256 = "0q9834siya19gj5ckymymyzkd1yn34b4xg5bvcgd7ckcpky143yw";
  };

  vendorSha256 = "1h0bbkp9g5nzzjm8qkaag54n9nl711ckkjwibb1gb9ciqwsad33l";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.Version=${version}" "-X main.GitTag=${src.rev}" "-X main.BuildDate=unknown" ];

  meta = with lib; {
    homepage = "https://github.com/securego/gosec";
    description = "Golang security checker";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit nilp0inter ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
