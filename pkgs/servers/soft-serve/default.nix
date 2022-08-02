{ lib, buildGoModule, fetchFromGitHub, makeWrapper, git }:

buildGoModule rec {
  pname = "soft-serve";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "soft-serve";
    rev = "v${version}";
    sha256 = "sha256-W/2MNiECzwgRv3jJG0To8vsQjQs8amaEP+dgig6JnOg=";
  };

  vendorSha256 = "sha256-98YT0UiVX+ONP+Vgsxf0UWOLF0VV4glEOfHYkGwB3Dg=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/soft \
      --prefix PATH : "${lib.makeBinPath [ git ]}"
  '';

  meta = with lib; {
    description = "A tasty, self-hosted Git server for the command line";
    homepage = "https://github.com/charmbracelet/soft-serve";
    changelog = "https://github.com/charmbracelet/soft-serve/releases/tag/v${version}";
    mainProgram = "soft";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
