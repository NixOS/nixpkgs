{ lib
, buildGoModule
, fetchFromGitHub
, file
, installShellFiles
, asciidoctor
}:

buildGoModule rec {
  pname = "pistol";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "doronbehar";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DGbWlEDI/qGNpdT8N79RsLxnUm4Sw8lHFRIBFd1GmK0=";
  };

  vendorSha256 = "sha256-poTd0lXRaJeDxwcw+h76NPC0mFB9nwm2vLLB5UUK1dk=";

  doCheck = false;

  subPackages = [ "cmd/pistol" ];

  buildInputs = [
    file
  ];
  nativeBuildInputs = [
    installShellFiles
    asciidoctor
  ];
  postBuild = ''
    asciidoctor -b manpage -d manpage README.adoc
    installManPage pistol.1
  '';

  ldflags = [ "-s" "-w" "-X main.Version=${version}" ];

  meta = with lib; {
    description = "General purpose file previewer designed for Ranger, Lf to make scope.sh redundant";
    homepage = "https://github.com/doronbehar/pistol";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
