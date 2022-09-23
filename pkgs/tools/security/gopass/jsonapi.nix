{ lib
, makeWrapper
, buildGoModule
, fetchFromGitHub
, installShellFiles
, gopass
}:

buildGoModule rec {
  pname = "gopass-jsonapi";
  version = "1.14.7";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2JfiwlJx7L2OhtAduq+4jxBquvvIq4Dwy6yr/SyX++E=";
  };

  vendorHash = "sha256-9T920rk51aTO7/6GhCPRM2rBD/b5wl09btyE5zPh6yU=";

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  ldflags = [
    "-s" "-w" "-X main.version=${version}" "-X main.commit=${src.rev}"
  ];

  postFixup = ''
    wrapProgram $out/bin/gopass-jsonapi \
      --prefix PATH : "${lib.makeBinPath [ gopass ]}"
  '';

  meta = with lib; {
    description = "Enables communication with gopass via JSON messages";
    homepage = "https://www.gopass.pw/";
    license = licenses.mit;
    maintainers = with maintainers; [ maxhbr ];
  };
}
