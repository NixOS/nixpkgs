{ lib
, makeWrapper
, buildGoModule
, fetchFromGitHub
, gopass
}:

buildGoModule rec {
  pname = "gopass-summon-provider";
  version = "1.14.9";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6uPW83/BnFtjfqCq5D3qpAZkqJG94ROUrgFbsEJBBcg=";
  };

  vendorHash = "sha256-7wDDHgLLoSIh/Qojz6cudUBN/HzS+ViZn0IZPRymAfg=";

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
    homepage = "https://www.gopass.pw/";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
  };
}
