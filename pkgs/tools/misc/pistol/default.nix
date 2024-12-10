{
  lib,
  buildGoModule,
  fetchFromGitHub,
  file,
  installShellFiles,
  asciidoctor,
}:

buildGoModule rec {
  pname = "pistol";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "doronbehar";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7nALrB+QubEnryVsGPpFMJ003SP2lheYTkWXF5w/V8I=";
  };

  vendorHash = "sha256-9Ydps8UA1f0fwG5SHRE4F61OyRJiITw/4SyoMEbsRgM=";

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

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    description = "General purpose file previewer designed for Ranger, Lf to make scope.sh redundant";
    homepage = "https://github.com/doronbehar/pistol";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
    mainProgram = "pistol";
  };
}
