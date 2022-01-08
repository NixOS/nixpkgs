{ lib, buildGoModule, fetchFromGitHub, makeWrapper, git }:

buildGoModule rec {
  pname = "soft-serve";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "soft-serve";
    rev = "v${version}";
    sha256 = "sha256-sRlEF1ee+oBnYOGSN6rDOvNr3OnfAqV+1Wx5XOyIylw=";
  };

  vendorSha256 = "sha256-FukkmuBTPPhY0UTe3r1iU3nbGoMsPTcRKTLBd+VMGUk=";

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
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
