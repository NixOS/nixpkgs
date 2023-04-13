{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, coreutils
, bash
, installShellFiles
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "just";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "casey";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-5JI3QaUuWvwI3pClZXMPU8v1lcPZ5YioMPGKl/lIjQ0=";
  };

  cargoHash = "sha256-91C/5m2avsW7GKQDg/Ez9fzzFhe8ih1De1RbV/MBJbM=";

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

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
  ];

  postInstall = ''
    installManPage man/just.1

    installShellCompletion --cmd just \
      --bash completions/just.bash \
      --fish completions/just.fish \
      --zsh completions/just.zsh
  '';

  meta = with lib; {
    homepage = "https://github.com/casey/just";
    changelog = "https://github.com/casey/just/blob/${version}/CHANGELOG.md";
    description = "A handy way to save and run project-specific commands";
    license = licenses.cc0;
    maintainers = with maintainers; [ xrelkd jk adamcstephens ];
  };
}
