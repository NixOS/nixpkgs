{ lib, buildGoModule, fetchFromGitHub, ronn, installShellFiles }:

buildGoModule rec {
  pname = "actionlint";
  version = "1.6.4";

  subPackages = [ "cmd/actionlint" ];

  src = fetchFromGitHub {
    owner = "rhysd";
    repo = "actionlint";
    rev = "v${version}";
    sha256 = "1516892wikz3zda0la57s8nbm6459pf4vd123rv09s4nivznbmcx";
  };

  vendorSha256 = "1i7442n621jmc974b73pfz1gyqw74ilpg1zz16yxqpfh5c958m7n";

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
  };
}
