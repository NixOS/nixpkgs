{ lib, buildGoModule, fetchFromGitHub, installShellFiles, makeWrapper, gnupg, bzip2, xz, graphviz, testers, aptly }:

buildGoModule rec {
  pname = "aptly";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "aptly-dev";
    repo = "aptly";
    rev = "v${version}";
    sha256 = "sha256-LqGOLXXaGfQfoj2r+aY9SdOKUDI9+22EsHKBhHMidyk=";
  };

  vendorHash = "sha256-6l3OFKFTtFWT68Ylav6woczBlMhD75C9ZoQ6OeLz0Cs=";

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  postInstall = ''
    installShellCompletion --bash --name aptly completion.d/aptly
    installShellCompletion --zsh --name _aptly completion.d/_aptly
    wrapProgram "$out/bin/aptly" \
      --prefix PATH ":" "${lib.makeBinPath [ gnupg bzip2 xz graphviz ]}"
  '';

  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = aptly;
    command = "aptly version";
  };

  meta = with lib; {
    homepage = "https://www.aptly.info";
    description = "Debian repository management tool";
    license = licenses.mit;
    maintainers = with maintainers; [ montag451 ] ++ teams.bitnomial.members;
    changelog =
      "https://github.com/aptly-dev/aptly/releases/tag/v${version}";
    mainProgram = "aptly";
  };
}
