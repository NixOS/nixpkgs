{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "labctl";
  version = "0.0.15";

  src = fetchFromGitHub {
    owner = "labctl";
    repo = "labctl";
    rev = "v${version}";
    hash = "sha256-txleZMgj/06PmP8Bv1J6n/2ywViNFqlgdCNzaTrY58c=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-JXFw/u8QaZKt+OjUWW0rPi9QDSkiqYyqcNCxyzvcDM4=";

  ldflags = [
    "-X=github.com/labctl/labctl/app.version=${version}"
    "-X=github.com/labctl/labctl/app.commit=${src.rev}"
    "-X=github.com/labctl/labctl/app.date=1970-01-01T00:00:00Z"
  ];

  postInstall = ''
    local INSTALL="$out/bin/labctl"
    installShellCompletion --cmd labctl \
      --bash <(echo "complete -C $INSTALL labctl") \
      --zsh <(echo "complete -o nospace -C $INSTALL labctl")
  '';

  meta = with lib; {
    description = "collection of helper tools for network engineers, while configuring and experimenting with their own network labs";
    homepage = "https://labctl.net";
    license = licenses.asl20;
    maintainers = with maintainers; [ janik ];
  };
}
