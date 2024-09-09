{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "ets";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "gdubicki";
    repo = "ets";
    rev = "v${version}";
    hash = "sha256-PowJ3ig8TfGx9P/PJPVBL8GsMh+gGZVt9l4Rf7Mqk00=";
  };

  vendorHash = "sha256-XHgdiXdp9aNEAc/Apvb64ExnpywjddWOw1scNKy+ico=";

  ldflags = [ "-s" "-w" "-X main.version=v${version}-nixpkgs" ];

  nativeBuildInputs = [ installShellFiles ];

  preBuild = ''
    rm -rf fixtures
  '';

  postInstall = ''
    installManPage ets.1
  '';

  doCheck = false;

  meta = with lib; {
    description = "Command output timestamper";
    homepage = "https://github.com/gdubicki/ets/";
    license = licenses.mit;
    maintainers = with maintainers; [ cameronfyfe ];
    mainProgram = "ets";
  };
}
