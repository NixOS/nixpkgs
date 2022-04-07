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
  version = "1.6.11";

  subPackages = [ "cmd/actionlint" ];

  src = fetchFromGitHub {
    owner = "rhysd";
    repo = "actionlint";
    rev = "v${version}";
    sha256 = "sha256-BlJxgRDnAlfM/81qAEGEW09luScivYSDf5w2lR8hQUA=";
  };

  vendorSha256 = "sha256-nG0u5hZ/YRn+yUoEGTBo6ZdOp0e+sH6Jl9F+QhpfYAU=";

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
