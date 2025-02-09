{ lib
, makeWrapper
, buildGoModule
, fetchFromGitHub
, installShellFiles
, gopass
}:

buildGoModule rec {
  pname = "gopass-jsonapi";
  version = "1.15.11";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass-jsonapi";
    rev = "v${version}";
    hash = "sha256-wJlnm+sgFg55LW4RWGjcT538DgNhJtFjwgwgqwLWH50=";
  };

  vendorHash = "sha256-qRmPO2WM9RD43twl5a47IT3xC1LGFwNF99ojIU2xg6A=";

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  ldflags = [
    "-s" "-w" "-X main.version=${version}" "-X main.commit=${src.rev}"
  ];

  postFixup = ''
    wrapProgram $out/bin/gopass-jsonapi \
      --prefix PATH : "${gopass.wrapperPath}"
  '';

  meta = with lib; {
    description = "Enables communication with gopass via JSON messages";
    homepage = "https://github.com/gopasspw/gopass-jsonapi";
    changelog = "https://github.com/gopasspw/gopass-jsonapi/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxhbr ];
    mainProgram = "gopass-jsonapi";
  };
}
