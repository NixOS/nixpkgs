{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  installShellFiles,
}:

buildGoModule rec {
  pname = "labctl";
  version = "0.0.22";

  src = fetchFromGitHub {
    owner = "labctl";
    repo = "labctl";
    rev = "v${version}";
    hash = "sha256-84t7qhLafNyPLgHmFQUsizEn6Us44dDTercGEm9lup4=";
  };

  patches = [
    # Fix build failure with Go 1.21 by updating go4.org/unsafe/assume-no-moving-gc
    # See https://github.com/labctl/labctl/pull/4
    (fetchpatch {
      url = "https://github.com/labctl/labctl/commit/615d05e94b991362beddce71c7ee34eae7fc93ff.patch";
      hash = "sha256-4JrXSsg8rfuH6i8XyLd/qO6AibkRMDBIpfT8r1yS75c=";
    })
  ];

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-Ycr/IZckIFysS9Goes58hhgh96UMRHjYWfWlQU23mXk=";

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
    mainProgram = "labctl";
  };
}
