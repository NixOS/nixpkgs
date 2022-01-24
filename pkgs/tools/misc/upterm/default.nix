{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles }:

buildGoModule rec {
  pname = "upterm";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "owenthereal";
    repo = "upterm";
    rev = "v${version}";
    sha256 = "sha256-JxyrH48CXaaa+LkTpUPsT9aq95IuuvDoyfZndrSF1IA=";
  };

  vendorSha256 = null;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    $out/bin/gendoc
    rm $out/bin/gendoc
    installManPage etc/man/man*/*
    installShellCompletion --bash --name upterm.bash etc/completion/upterm.bash_completion.sh
    installShellCompletion --zsh --name _upterm etc/completion/upterm.zsh_completion
  '';

  doCheck = true;

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Secure terminal-session sharing";
    homepage = "https://upterm.dev";
    license = licenses.asl20;
    maintainers = with maintainers; [ hax404 ];
  };
}
