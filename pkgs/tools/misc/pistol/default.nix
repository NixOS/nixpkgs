{ lib
, buildGoModule
, fetchFromGitHub
, file
, installShellFiles
, asciidoctor
}:

buildGoModule rec {
  pname = "pistol";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "doronbehar";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xzVVOx5Uz10Bv8LDRuqqxyjdYp1JKhQPb3ws2l6Dg2Y=";
  };

  vendorHash = "sha256-9+eWTpz2VcNtEwVtVdNPjXYdG7XjB7cvC4WWvxF7Lvs=";

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
    mainProgram = "pistol";
  };
}
