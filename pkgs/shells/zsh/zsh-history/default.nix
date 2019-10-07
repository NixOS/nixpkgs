{ lib, fetchFromGitHub, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "zsh-history";
  version = "2019-10-07";

  src = fetchFromGitHub {
    owner = "b4b4r07";
    repo = "history";
    rev = "a08ad2dcffc852903ae54b0c5704b8a085009ef7";
    sha256 = "0r3p04my40dagsq1dssnk583qrlcps9f7ajp43z7mq73q3hrya5s";
  };

  nativeBuildInputs = [ installShellFiles ];

  modSha256 = "0f10b86gyn7m7lw43c8y1m30mdg0i092a319v3cb2qj05jb9vn42";
  goPackagePath = "github.com/b4b4r07/history";

  postInstall = ''
    install -d $out/share
    cp -r "$NIX_BUILD_TOP/source/misc/"* "$out/share"
    installShellCompletion --zsh --name _history $out/share/zsh/completions/_history
  '';

  meta = with lib; {
    description = "A CLI to provide enhanced history for your ZSH shell";
    license = licenses.mit;
    homepage = https://github.com/b4b4r07/history;
    platforms = platforms.unix;
    maintainers = with maintainers; [ kampka ];
  };
}
