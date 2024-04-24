{ lib, fetchFromGitHub, buildGoModule, installShellFiles, nixosTests }:

buildGoModule rec {
  pname = "zsh-history";
  version = "2019-12-10";

  src = fetchFromGitHub {
    owner = "b4b4r07";
    repo = "history";
    rev = "8da016bd91b0c2eb53c9980f00eee6abdbb097e2";
    sha256 = "13n643ik1zjvpk8h9458yd9ffahhbdnigmbrbmpn7b7g23wqqsi3";
  };

  vendorHash = "sha256-n5QFN1B2GjbzylFuW9Y4r0+ioIJlfKwcGK8X3ZwKLI8=";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  postInstall = ''
    install -d $out/share
    cp -r "$NIX_BUILD_TOP/source/misc/"* "$out/share"
    installShellCompletion --zsh --name _history $out/share/zsh/completions/_history
  '';

  passthru.tests = {
    zsh-history-shell-integration = nixosTests.zsh-history;
  };

  meta = with lib; {
    description = "A CLI to provide enhanced history for your ZSH shell";
    homepage = "https://github.com/b4b4r07/history";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "history";
  };
}
