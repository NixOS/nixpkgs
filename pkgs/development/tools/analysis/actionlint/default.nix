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
  version = "1.6.15";

  subPackages = [ "cmd/actionlint" ];

  src = fetchFromGitHub {
    owner = "rhysd";
    repo = "actionlint";
    rev = "v${version}";
    sha256 = "sha256-AhV5D0ujTjYvlcEbmqSZ2VPTKDQHZ6/lJpt9DlY2q7c=";
  };

  vendorSha256 = "sha256-wKK597mk51jT6s1eKA4AjiCvI4IkZ9WjMXxaY8AWwkU=";

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
    maintainers = [ maintainers.marsam ];
    mainProgram = "actionlint";
  };
}
