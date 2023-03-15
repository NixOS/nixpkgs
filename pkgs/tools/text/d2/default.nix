{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, testers
, d2
}:

buildGoModule rec {
  pname = "d2";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "terrastruct";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-aReYFw6mlPhf11bhLII5CrMG1G9d0hhPsFVrZxmt72o=";
  };

  vendorHash = "sha256-+Z8nzna5KedWzmhBKGSpsbE8ooaC9sPk6Bh5zkrzwrQ=";

  ldflags = [
    "-s"
    "-w"
    "-X oss.terrastruct.com/d2/lib/version.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage ci/release/template/man/d2.1
  '';

  subPackages = [ "." ];

  passthru.tests.version = testers.testVersion { package = d2; };

  meta = with lib; {
    description = "A modern diagram scripting language that turns text to diagrams";
    homepage = "https://d2lang.com";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
