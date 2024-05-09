{ lib, buildGoModule, fetchFromGitHub, asciidoctor, installShellFiles }:

buildGoModule rec {
  pname = "webcat";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "rumpelsepp";
    repo = "webcat";
    rev = "v${version}";
    hash = "sha256-JyZHH8JgS3uoNVicx1wj0SAzlrXyTrpwIBZuok6buRw=";
  };

  vendorHash = "sha256-duVp/obT+5M4Dl3BAdSgRaP3+LKmS0y51loMMdoGysw=";

  nativeBuildInputs = [ asciidoctor installShellFiles ];

  postInstall = ''
    make -C man man
    installManPage man/webcat.1
  '';

  meta = with lib; {
    homepage = "https://rumpelsepp.org/blog/ssh-through-websocket/";
    description = "The lightweight swiss army knife for websockets";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ montag451 ];
    mainProgram = "webcat";
  };
}
