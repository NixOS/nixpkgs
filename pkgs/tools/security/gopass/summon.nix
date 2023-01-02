{ lib
, makeWrapper
, buildGoModule
, fetchFromGitHub
, gopass
}:

buildGoModule rec {
  pname = "gopass-summon-provider";
  version = "1.15.2";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-tcRdb6zkFO/fhCm9YE7qDPYROuOrsN2BeeX+TtTnaHc=";
  };

  vendorHash = "sha256-1pQ+f+m+cff6M0sfydaqGyvXqS6lyi9mfi9Pl4tynhU=";

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
