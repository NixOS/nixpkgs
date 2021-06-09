{ lib, fetchFromGitHub, stdenv, rustPlatform, coreutils, bash, installShellFiles, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "just";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "casey";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-C0W5oMnKlQ5hg/0YLKZKiQfLghJ7yAJYW6k0G6eOFQE=";
  };

  cargoSha256 = "sha256-TqvUunBFpKIog0pG85M/JLz8orncgbRqnQolseXYSo4=";

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

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
  ];

  meta = with lib; {
    homepage = "https://github.com/casey/just";
    changelog = "https://github.com/casey/just/blob/v${version}/CHANGELOG.md";
    description = "A handy way to save and run project-specific commands";
    license = licenses.cc0;
    maintainers = with maintainers; [ xrelkd jk ];
  };
}
