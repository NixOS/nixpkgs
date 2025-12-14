{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  gopass,
}:

buildGoModule (finalAttrs: {
  pname = "gopass-summon-provider";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass-summon-provider";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j3N/snUCsw/NlMQO9CoVRf6JCG48DEHqrJnZ7wiVUPk=";
  };

  vendorHash = "sha256-FhS79dSY9FjlScoXd6EbYRRwEBObZLO9g/SXBEXQpjM=";

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.src.rev}"
  ];

  postFixup = ''
    wrapProgram $out/bin/gopass-summon-provider \
      --prefix PATH : "${lib.makeBinPath [ gopass ]}"
  '';

  meta = {
    description = "Gopass Summon Provider";
    homepage = "https://github.com/gopasspw/gopass-summon-provider";
    changelog = "https://github.com/gopasspw/gopass-summon-provider/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sikmir ];
    mainProgram = "gopass-summon-provider";
  };
})
