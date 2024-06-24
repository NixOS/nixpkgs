{ lib, buildGoModule, fetchFromGitHub, makeWrapper, stdenv }:

buildGoModule rec {
  pname = "delve";
  version = "1.22.1";

  src = fetchFromGitHub {
    owner = "go-delve";
    repo = "delve";
    rev = "v${version}";
    hash = "sha256-rR84muba8nMrPZAhH+8xXOOxBvKIsU8Xju8tG7BjqBo=";
  };

  vendorHash = null;

  subPackages = [ "cmd/dlv" ];

  nativeBuildInputs = [ makeWrapper ];

  hardeningDisable = [ "fortify" ];

  preCheck = ''
    XDG_CONFIG_HOME=$(mktemp -d)
  '';

  # Disable tests on Darwin as they require various workarounds.
  #
  # - Tests requiring local networking fail with or without sandbox,
  #   even with __darwinAllowLocalNetworking allowed.
  # - CGO_FLAGS warnings break tests' expected stdout/stderr outputs.
  # - DAP test binaries exit prematurely.
  doCheck = !stdenv.isDarwin;

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
    maintainers = with maintainers; [ vdemeester ];
    license = licenses.mit;
    mainProgram = "dlv";
  };
}
