{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, coreutils
, installShellFiles
, libiconv
, mdbook
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "just";
  version = "1.18.1";
  outputs = [ "out" "man" "doc" ];

  src = fetchFromGitHub {
    owner = "casey";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-jmTSTx2WSLOtxy0gPCTonjcoy4o9FKA5aiQW3+wPrZQ=";
  };

  cargoHash = "sha256-4kbvtmXkU5bhuC079K5NOGKVdqYvTileVNXSNLIV0ok=";

  nativeBuildInputs = [ installShellFiles mdbook ];
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

  postBuild = ''
    cargo run --package generate-book

    # No linkcheck in sandbox
    echo 'optional = true' >> book/en/book.toml
    mdbook build book/en
    find .
  '';

  checkFlags = [
    "--skip=edit" # trying to run "vim" fails as there's no /usr/bin/env or which in the sandbox to find vim and the dependency is not easily patched
    "--skip=run_shebang" # test case very rarely fails with "Text file busy"
    "--skip=invoke_error_function" # wants JUST_CHOOSER to be fzf
    "--skip=choose::default" # symlinks cat->fzf which fails as coreutils doesn't understand name
  ];

  postInstall = ''
    mkdir -p $doc/share/doc/$name
    mv ./book/en/build/html $doc/share/doc/$name
    installManPage man/just.1

    installShellCompletion --cmd just \
      --bash completions/just.bash \
      --fish completions/just.fish \
      --zsh completions/just.zsh
  '';

  setupHook = ./setup-hook.sh;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/casey/just";
    changelog = "https://github.com/casey/just/blob/${version}/CHANGELOG.md";
    description = "A handy way to save and run project-specific commands";
    license = licenses.cc0;
    maintainers = with maintainers; [ xrelkd jk adamcstephens ];
    mainProgram = "just";
  };
}
