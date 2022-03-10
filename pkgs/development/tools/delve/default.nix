{ lib, buildGoPackage, fetchFromGitHub, makeWrapper }:

buildGoPackage rec {
  pname = "delve";
  version = "1.8.1";

  goPackagePath = "github.com/go-delve/delve";
  excludedPackages = "\\(_fixtures\\|scripts\\|service/test\\)";

  src = fetchFromGitHub {
    owner = "go-delve";
    repo = "delve";
    rev = "v${version}";
    sha256 = "sha256-GIwu3G8cy2xKqFzN/7d/mbpS+5oGJa3QexoELlEwWRA=";
  };

  subPackages = [ "cmd/dlv" ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    # fortify source breaks build since delve compiles with -O0
    wrapProgram $out/bin/dlv \
      --prefix disableHardening " " fortify

    # add symlink for vscode golang extension
    # https://github.com/golang/vscode-go/blob/master/docs/debugging.md#manually-installing-dlv-dap
    ln $out/bin/dlv $out/bin/dlv-dap
  '';

  meta = with lib; {
    description = "debugger for the Go programming language";
    homepage = "https://github.com/go-delve/delve";
    maintainers = with maintainers; [ SuperSandro2000 vdemeester ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" ] ++ platforms.darwin;
  };
}
