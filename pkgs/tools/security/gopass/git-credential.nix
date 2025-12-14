{
  lib,
  makeWrapper,
  buildGoModule,
  fetchFromGitHub,
  gopass,
}:

buildGoModule rec {
  pname = "git-credential-gopass";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "git-credential-gopass";
    rev = "v${version}";
    hash = "sha256-IEur3Sw2zRYJxlwAhgpb2OnBt+FcC+OdeT7M/LzJwoY=";
  };

  vendorHash = "sha256-mtJIm7dH3jP7p0R0KxN0Yf7mi9rkJ73u8biy2Ygvk3k=";

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

  meta = {
    description = "Manage git credentials using gopass";
    homepage = "https://github.com/gopasspw/git-credential-gopass";
    changelog = "https://github.com/gopasspw/git-credential-gopass/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ benneti ];
    mainProgram = "git-credential-gopass";
  };
}
