{ lib
, makeWrapper
, buildGoModule
, fetchFromGitHub
, installShellFiles
, gopass
}:

buildGoModule rec {
  pname = "gopass-jsonapi";
  version = "1.15.9";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass-jsonapi";
    rev = "v${version}";
    hash = "sha256-p1z1jFk+Fmh7kMyMI5kMCkmp62q/CC8BqsbHHpfGWaI=";
  };

  vendorHash = "sha256-bFHm2mSWI00lVAfFK8DSjt0hgM52IycpHGRADk0QSoQ=";

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
