{ lib
, buildGoModule
, fetchFromGitHub
, file
, installShellFiles
, asciidoctor
}:

buildGoModule rec {
  pname = "pistol";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "doronbehar";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-C0X9LdCgfv+IFHsNLOumH1e/RAh6NycmE/J4SdA6AMs=";
  };

  vendorHash = "sha256-3H3XAJ9gNBd+IjxpjfUFl2/3NWN1E+6aey4i4ajOIiY=";

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
