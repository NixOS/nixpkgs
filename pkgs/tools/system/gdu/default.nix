{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  gdu,
}:

buildGoModule rec {
  pname = "gdu";
  version = "5.29.0";

  src = fetchFromGitHub {
    owner = "dundee";
    repo = "gdu";
    rev = "refs/tags/v${version}";
    hash = "sha256-w48I7HU/pA53Pq6ZVwtby+YvFddVUjj8orL40Gifqoo=";
  };

  vendorHash = "sha256-aKhHC3sPRyi/l9BxeUgx+3TdYulb0cI9WxuPvbLoswg=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/dundee/gdu/v${lib.versions.major version}/build.Version=${version}"
  ];

  postPatch = ''
    substituteInPlace cmd/gdu/app/app_test.go \
      --replace-fail "development" "${version}"
  '';

  postInstall = ''
    installManPage gdu.1
  '';

  doCheck = !stdenv.isDarwin;

  checkFlags = [
    # https://github.com/dundee/gdu/issues/371
    "-skip=TestStoredAnalyzer"
  ];

  passthru.tests.version = testers.testVersion { package = gdu; };

  meta = with lib; {
    description = "Disk usage analyzer with console interface";
    longDescription = ''
      Gdu is intended primarily for SSD disks where it can fully
      utilize parallel processing. However HDDs work as well, but
      the performance gain is not so huge.
    '';
    homepage = "https://github.com/dundee/gdu";
    changelog = "https://github.com/dundee/gdu/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [
      fab
      zowoq
    ];
    mainProgram = "gdu";
  };
}
