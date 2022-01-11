{ lib, buildGoModule, fetchFromGitea, asciidoctor, installShellFiles }:

buildGoModule rec {
  pname = "webcat";
  version = "unstable-2021-09-06";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "rumpelsepp";
    repo = "webcat";
    rev = "57a65558f0affac0b2f8f4831c52964eb9ad5386";
    sha256 = "15c62sjr15l5hwkvc4xarfn76341wi16pjv9qbr1agaz1vqgr6rd";
  };

  vendorSha256 = "1apnra58mqrazbq53f0qlqnyyhjdvvdz995yridxva0fxmwpwcjy";

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
  };
}
