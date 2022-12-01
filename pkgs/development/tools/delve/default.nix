{ lib, buildGoModule, fetchFromGitHub, makeWrapper, stdenv }:

buildGoModule rec {
  pname = "delve";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "go-delve";
    repo = "delve";
    rev = "v${version}";
    sha256 = "sha256-Ga+1xz7gsLoHA0G4UOiJf331hrBVoeB93Pjd0PyATB4=";
  };

  vendorSha256 = null;

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
    maintainers = with maintainers; [ SuperSandro2000 vdemeester ];
    license = licenses.mit;
  };
}
