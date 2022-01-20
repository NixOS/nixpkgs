{ lib, buildGoModule, fetchFromGitHub, ronn, installShellFiles }:

buildGoModule rec {
  pname = "actionlint";
  version = "1.6.8";

  subPackages = [ "cmd/actionlint" ];

  src = fetchFromGitHub {
    owner = "rhysd";
    repo = "actionlint";
    rev = "v${version}";
    sha256 = "sha256-wjLY40bxpoMk6YIG/4KbjxSWUDVNn3cX5OcsgfEPjzk=";
  };

  vendorSha256 = "sha256-0tytdTZxnWYl8AxaquF0ArY3dy51j8H2kzw69qcSHzk=";

  nativeBuildInputs = [ ronn installShellFiles ];

  postInstall = ''
    ronn --roff man/actionlint.1.ronn
    installManPage man/actionlint.1
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
