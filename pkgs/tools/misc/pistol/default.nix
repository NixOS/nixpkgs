{ lib
, buildGoModule
, fetchFromGitHub
, file
, installShellFiles
, asciidoctor
}:

buildGoModule rec {
  pname = "pistol";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "doronbehar";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6V3Du3+0YliwzsvZolapBAnyqbsv1WZhWQkaldDR+Ok=";
  };

  vendorSha256 = "sha256-jURN0NSc9SFHFMS8QdaEqqBwOHnAEEJQlQXHTUDRiyE=";

  doCheck = false;

  subPackages = [ "cmd/pistol" ];

  buildInputs = [
    file
  ];
  nativeBuildInputs = [
    installShellFiles
    asciidoctor
  ];
  postInstall = ''
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
