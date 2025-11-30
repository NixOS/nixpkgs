{
  lib,
  makeWrapper,
  buildGoModule,
  fetchFromGitHub,
  gopass,
}:

buildGoModule rec {
  pname = "gopass-summon-provider";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass-summon-provider";
    rev = "v${version}";
    hash = "sha256-ES+lU0iBwzkomWoVKQrKElOaH9XiumnzpBVRjWbI/cM=";
  };

  vendorHash = "sha256-gE8x+81DFzw0TSkxwU5s+OQccSvfRVH6dV+sWhMdBxI=";

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=${src.rev}"
  ];

  postFixup = ''
    wrapProgram $out/bin/gopass-summon-provider \
      --prefix PATH : "${lib.makeBinPath [ gopass ]}"
  '';

  meta = with lib; {
    description = "Gopass Summon Provider";
    homepage = "https://github.com/gopasspw/gopass-summon-provider";
    changelog = "https://github.com/gopasspw/gopass-summon-provider/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    mainProgram = "gopass-summon-provider";
  };
}
