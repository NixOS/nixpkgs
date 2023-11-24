{ lib
, makeWrapper
, buildGoModule
, fetchFromGitHub
, gopass
}:

buildGoModule rec {
  pname = "gopass-summon-provider";
  version = "1.15.9";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass-summon-provider";
    rev = "v${version}";
    hash = "sha256-Ob/G1xDAgPlh2aM+TwbpycqhTodHNs97pvBpCWTYxXE=";
  };

  vendorHash = "sha256-znmBV6sLx0g7zKkkv3S4TfVQu79ch5epq8l2uImF/Go=";

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s" "-w" "-X main.version=${version}" "-X main.commit=${src.rev}"
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
