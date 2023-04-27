{ lib
, makeWrapper
, buildGoModule
, fetchFromGitHub
, gopass
}:

buildGoModule rec {
  pname = "gopass-summon-provider";
  version = "1.15.5";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass-summon-provider";
    rev = "v${version}";
    hash = "sha256-ZAXdazhRqg9TbWWbftz9og3H7LTHenLlpFPIgZQHd/Q=";
  };

  vendorHash = "sha256-BXzXpG1Dy25IBf8EzgzOnFcbEvQGVhO8jgR/t6IKgPw=";

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
