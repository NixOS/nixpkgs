{ lib
, makeWrapper
, buildGoModule
, fetchFromGitHub
, gopass
}:

buildGoModule rec {
  pname = "gopass-hibp";
  version = "1.15.10";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass-hibp";
    rev = "v${version}";
    hash = "sha256-v3FtWBi5H9LiFN/mowufonABr+aV3Z8MWBKiIUoy0NE=";
  };

  vendorHash = "sha256-c4kk1RrvB+c+8IfbIsLRvG7O3cy+u9l+pDZ52XX1AhI=";

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [
    "-s" "-w" "-X main.version=${version}" "-X main.commit=${src.rev}"
  ];

  postFixup = ''
    wrapProgram $out/bin/gopass-hibp \
      --prefix PATH : "${lib.makeBinPath [ gopass ]}"
  '';

  meta = with lib; {
    description = "Gopass haveibeenpwnd.com integration";
    homepage = "https://github.com/gopasspw/gopass-hibp";
    changelog = "https://github.com/gopasspw/gopass-hibp/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    mainProgram = "gopass-hibp";
  };
}
