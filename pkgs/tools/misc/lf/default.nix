{ buildGoModule, fetchFromGitHub, lib, installShellFiles }:

buildGoModule rec {
  pname = "lf";
  version = "21";

  src = fetchFromGitHub {
    owner = "gokcehan";
    repo = "lf";
    rev = "r${version}";
    sha256 = "0j7c21lsgcc39ng9ni94y3zfcqwyf9jc52fi8mcpkp0lpcx5ava9";
  };

  vendorSha256 = "15fl9v69wkzwzpq6x4xhcd5g6xyck3mlpbz1bbb61l75jjzg913m";

  nativeBuildInputs = [ installShellFiles ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.gVersion=r${version}" ];

  postInstall = ''
    install -D --mode=444 lf.desktop $out/share/applications/lf.desktop
    installManPage lf.1
    installShellCompletion etc/lf.{zsh,fish}
  '';

  meta = with lib; {
    description = "A terminal file manager written in Go and heavily inspired by ranger";
    longDescription = ''
      lf (as in "list files") is a terminal file manager written in Go. It is
      heavily inspired by ranger with some missing and extra features. Some of
      the missing features are deliberately omitted since it is better if they
      are handled by external tools.
    '';
    homepage = "https://godoc.org/github.com/gokcehan/lf";
    changelog = "https://github.com/gokcehan/lf/releases/tag/r${version}";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
