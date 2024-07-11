{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, makeWrapper
, python3Packages
, ronn
, shellcheck
}:

buildGoModule rec {
  pname = "actionlint";
  version = "1.7.1";

  subPackages = [ "cmd/actionlint" ];

  src = fetchFromGitHub {
    owner = "rhysd";
    repo = "actionlint";
    rev = "v${version}";
    hash = "sha256-nu3Bj85L68YFNE4loh548A8ik3NCj4V32FlDV8V6BEE=";
  };

  vendorHash = "sha256-ZREtrdHUD1B1Mogidp1y/kFTK+KR4qYJj1c/M+0utPM=";

  nativeBuildInputs = [ makeWrapper ronn installShellFiles ];

  postInstall = ''
    ronn --roff man/actionlint.1.ronn
    installManPage man/actionlint.1
    wrapProgram "$out/bin/actionlint" \
      --prefix PATH : ${lib.makeBinPath [ python3Packages.pyflakes shellcheck ]}
  '';

  ldflags = [ "-s" "-w" "-X github.com/rhysd/actionlint.version=${version}" ];

  meta = with lib; {
    homepage = "https://rhysd.github.io/actionlint/";
    description = "Static checker for GitHub Actions workflow files";
    changelog = "https://github.com/rhysd/actionlint/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "actionlint";
  };
}
