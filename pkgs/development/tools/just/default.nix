{ lib, fetchFromGitHub, stdenv, rustPlatform, coreutils, bash, installShellFiles, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "just";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "casey";
    repo = pname;
    rev = version;
    sha256 = "sha256-r6kP1LbT8ZQoxSuy7jpnHD2/RgcPvmTNfjKzj5ceXRc=";
  };
  cargoSha256 = "sha256-y6RcFH2qDoM3wWnZ6ewC9QyRD3mFsoakToRmon4bAnE=";

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  postPatch = ''
    # this hard codes the compiler, which breaks the aarch64 in particular
    # we rather want to set the compiler ourself
    rm .cargo/config
  '';

  postInstall = ''
    installManPage man/just.1

    installShellCompletion --cmd just \
      --bash completions/just.bash \
      --fish completions/just.fish \
      --zsh  completions/just.zsh
  '';

  checkInputs = [ coreutils bash ];

  preCheck = ''
    # USER must not be empty
    export USER=just-user
    export USERNAME=just-user
    export JUST_CHOOSER="${coreutils}/bin/cat"

    # Prevent string.rs from being changed
    cp tests/string.rs $TMPDIR/string.rs

    sed -i src/justfile.rs \
        -i tests/*.rs \
        -e "s@/bin/echo@${coreutils}/bin/echo@g" \
        -e "s@/usr/bin/env@${coreutils}/bin/env@g"

    # Return unchanged string.rs
    cp $TMPDIR/string.rs tests/string.rs
  '';

  checkFlags = [
    "--skip=edit" # trying to run "vim" fails as there's no /usr/bin/env or which in the sandbox to find vim and the dependency is not easily patched
    "--skip=run_shebang" # test case very rarely fails with "Text file busy"
    "--skip=invoke_error_function" # wants JUST_CHOOSER to be fzf
    "--skip=status_error" # "exit status" instead of "exit code"
    "--skip=exit_status" # "exit status" instead of "exit code"
  ];

  meta = with lib; {
    homepage = "https://github.com/casey/just";
    changelog = "https://github.com/casey/just/blob/${version}/CHANGELOG.md";
    description = "A handy way to save and run project-specific commands";
    license = licenses.cc0;
    maintainers = with maintainers; [ xrelkd jk ];
  };
}
