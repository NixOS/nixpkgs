{
  lib,
  makeWrapper,
  buildGoModule,
  fetchFromGitHub,
  gopass,
}:

buildGoModule rec {
  pname = "git-credential-gopass";
  version = "1.15.17";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "git-credential-gopass";
    rev = "v${version}";
    hash = "sha256-dMCDRrq0o6naobsnKLedY6ORJdEOPdGG7L49VmcQiJQ=";
  };

  vendorHash = "sha256-MoellcZ/4iDu1hZ/5qvupfozl+iUP7Uc4RV0LxPaIOc=";

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=${src.rev}"
  ];

  postFixup = ''
    wrapProgram $out/bin/git-credential-gopass \
      --prefix PATH : "${lib.makeBinPath [ gopass ]}"
  '';

  meta = with lib; {
    description = "Manage git credentials using gopass";
    homepage = "https://github.com/gopasspw/git-credential-gopass";
    changelog = "https://github.com/gopasspw/git-credential-gopass/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ benneti ];
    mainProgram = "git-credential-gopass";
  };
}
