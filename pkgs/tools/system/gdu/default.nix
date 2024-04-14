{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
, testers
, gdu
}:

buildGoModule rec {
  pname = "gdu";
  version = "5.27.0";

  src = fetchFromGitHub {
    owner = "dundee";
    repo = "gdu";
    rev = "refs/tags/v${version}";
    hash = "sha256-hQyvYLegGimYTRz0J/2tmaC6N4LfjB1ivWgN29DwNhA=";
  };

  vendorHash = "sha256-weNcJjofI7Aoy0Eya0KprXHAn7aTA0rQJYrJ4+t65hI=";

  nativeBuildInputs = [
    installShellFiles
  ];

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

  passthru.tests.version = testers.testVersion {
    package = gdu;
  };

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
    maintainers = with maintainers; [ fab zowoq ];
    mainProgram = "gdu";
  };
}
