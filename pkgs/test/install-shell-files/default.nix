{
  lib,
  runCommandLocal,
  recurseIntoAttrs,
  installShellFiles,
}:

let
  runTest =
    name: env: buildCommand:
    runCommandLocal "install-shell-files--${name}" (
      {
        nativeBuildInputs = [ installShellFiles ];
        meta.platforms = lib.platforms.all;
      }
      // env
    ) buildCommand;
in

recurseIntoAttrs {
  # installManPage

  install-manpage = runTest "install-manpage" { } ''
    mkdir -p doc
    echo foo > doc/foo.1
    echo bar > doc/bar.2.gz
    echo baz > doc/baz.3

    installManPage doc/*

    cmp doc/foo.1 $out/share/man/man1/foo.1
    cmp doc/bar.2.gz $out/share/man/man2/bar.2.gz
    cmp doc/baz.3 $out/share/man/man3/baz.3
  '';
  install-manpage-outputs =
    runTest "install-manpage-outputs"
      {
        outputs = [
          "out"
          "man"
          "devman"
        ];
      }
      ''
        mkdir -p doc
        echo foo > doc/foo.1
        echo bar > doc/bar.3

        installManPage doc/*

        # assert they didn't go into $out
        [[ ! -f $out/share/man/man1/foo.1 && ! -f $out/share/man/man3/bar.3 ]]

        # foo.1 alone went into man
        cmp doc/foo.1 ''${!outputMan:?}/share/man/man1/foo.1
        [[ ! -f ''${!outputMan:?}/share/man/man3/bar.3 ]]

        # bar.3 alone went into devman
        cmp doc/bar.3 ''${!outputDevman:?}/share/man/man3/bar.3
        [[ ! -f ''${!outputDevman:?}/share/man/man1/foo.1 ]]

        touch $out
      '';

  # installShellCompletion

  install-completion = runTest "install-completion" { } ''
    echo foo > foo
    echo bar > bar
    echo baz > baz
    echo qux > qux.zsh
    echo quux > quux

    installShellCompletion --bash foo bar --zsh baz qux.zsh --fish quux

    cmp foo $out/share/bash-completion/completions/foo
    cmp bar $out/share/bash-completion/completions/bar
    cmp baz $out/share/zsh/site-functions/_baz
    cmp qux.zsh $out/share/zsh/site-functions/_qux
    cmp quux $out/share/fish/vendor_completions.d/quux
  '';
  install-completion-output =
    runTest "install-completion-output"
      {
        outputs = [
          "out"
          "bin"
        ];
      }
      ''
        echo foo > foo

        installShellCompletion --bash foo

        # assert it didn't go into $out
        [[ ! -f $out/share/bash-completion/completions/foo ]]

        cmp foo ''${!outputBin:?}/share/bash-completion/completions/foo

        touch $out
      '';
  install-completion-name = runTest "install-completion-name" { } ''
    echo foo > foo
    echo bar > bar
    echo baz > baz

    installShellCompletion --bash --name foobar.bash foo --zsh --name _foobar bar --fish baz

    cmp foo $out/share/bash-completion/completions/foobar.bash
    cmp bar $out/share/zsh/site-functions/_foobar
    cmp baz $out/share/fish/vendor_completions.d/baz
  '';
  install-completion-inference = runTest "install-completion-inference" { } ''
    echo foo > foo.bash
    echo bar > bar.zsh
    echo baz > baz.fish

    installShellCompletion foo.bash bar.zsh baz.fish

    cmp foo.bash $out/share/bash-completion/completions/foo.bash
    cmp bar.zsh $out/share/zsh/site-functions/_bar
    cmp baz.fish $out/share/fish/vendor_completions.d/baz.fish
  '';
  install-completion-cmd = runTest "install-completion-cmd" { } ''
    echo foo > foo.bash
    echo bar > bar.zsh
    echo baz > baz.fish
    echo qux > qux.fish

    installShellCompletion --cmd foobar --bash foo.bash --zsh bar.zsh --fish baz.fish --name qux qux.fish

    cmp foo.bash $out/share/bash-completion/completions/foobar.bash
    cmp bar.zsh $out/share/zsh/site-functions/_foobar
    cmp baz.fish $out/share/fish/vendor_completions.d/foobar.fish
    cmp qux.fish $out/share/fish/vendor_completions.d/qux
  '';
  install-completion-fifo = runTest "install-completion-fifo" { } ''
    installShellCompletion \
      --bash --name foo.bash <(echo foo) \
      --zsh --name _foo <(echo bar) \
      --fish --name foo.fish <(echo baz)

    [[ $(<$out/share/bash-completion/completions/foo.bash) == foo ]] || { echo "foo.bash comparison failed"; exit 1; }
    [[ $(<$out/share/zsh/site-functions/_foo) == bar ]] || { echo "_foo comparison failed"; exit 1; }
    [[ $(<$out/share/fish/vendor_completions.d/foo.fish) == baz ]] || { echo "foo.fish comparison failed"; exit 1; }
  '';
}
