{
  lib,
  makeWrapper,
  buildGoModule,
  fetchFromGitHub,
  gopass,
}:

buildGoModule rec {
  pname = "gopass-summon-provider";
  version = "1.15.15";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass-summon-provider";
    rev = "v${version}";
    hash = "sha256-yMua3BSl4u/1axLMmLIzjqj8wYvMMPTqmRgcuH1tqN0=";
  };

  vendorHash = "sha256-onpg0CRm5HSfMEejhn2ycnV1GuukX1SK4FZN/KjEiR4=";

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
