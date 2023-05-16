{ lib, buildGoModule, fetchFromGitHub, makeWrapper, stdenv }:

buildGoModule rec {
  pname = "delve";
<<<<<<< HEAD
  version = "1.21.0";
=======
  version = "1.20.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "go-delve";
    repo = "delve";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-bDxpXm53PCdUQDq6pIigutY1JxrGWfsPkVSA+0i3vr0=";
=======
    sha256 = "sha256-NHVgNoMa/K1wVbXKycd7sdxfCpLYY6kn2uSfJWUpq1o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ vdemeester ];
=======
    maintainers = with maintainers; [ SuperSandro2000 vdemeester ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    mainProgram = "dlv";
  };
}
