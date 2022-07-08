{ lib, buildGoModule, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "delve";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "go-delve";
    repo = "delve";
    rev = "v${version}";
    sha256 = "sha256-paNr9aiRG6NP6DIGUojl7VPPPMTeJRpDW8ThDNOQhWM=";
  };

  vendorSha256 = null;

  subPackages = [ "cmd/dlv" ];

  nativeBuildInputs = [ makeWrapper ];

  checkFlags = [ "-short" ];

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
  };
}
