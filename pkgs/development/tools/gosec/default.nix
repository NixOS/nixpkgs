{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gosec";
  version = "2.20.0";

  src = fetchFromGitHub {
    owner = "securego";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QQD24Z755AurBFXZj/wlRBJegQ74kTvWVy2cN5PnblY=";
  };

  vendorHash = "sha256-VWbsSS3j8zgsZQzsO/ZyKoOUqhNhmMmDICImUZHmC9Y=";

  subPackages = [
    "cmd/gosec"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X main.GitTag=${src.rev}"
    "-X main.BuildDate=unknown"
  ];

  meta = with lib; {
    homepage = "https://github.com/securego/gosec";
    description = "Golang security checker";
    mainProgram = "gosec";
    license = licenses.asl20;
    maintainers = with maintainers; [
      kalbasit
      nilp0inter
    ];
  };
}
