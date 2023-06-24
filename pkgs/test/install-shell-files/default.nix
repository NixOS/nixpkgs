{ lib, runCommandLocal, recurseIntoAttrs, installShellFiles }:

let
  runTest = name: env: buildCommand:
    runCommandLocal "install-shell-files--${name}" ({
      nativeBuildInputs = [ installShellFiles ];
      meta.platforms = lib.platforms.all;
    } // env) buildCommand;
in

recurseIntoAttrs {
  # installManPage

  install-manpage = runTest "install-manpage" {} ''
    mkdir -p doc
    echo foo > doc/foo.1
    echo bar > doc/bar.2.gz
    echo baz > doc/baz.3

    installManPage doc/*

    cmp doc/foo.1 $out/share/man/man1/foo.1
    cmp doc/bar.2.gz $out/share/man/man2/bar.2.gz
    cmp doc/baz.3 $out/share/man/man3/baz.3
  '';
  install-manpage-outputs = runTest "install-manpage-outputs" {
    outputs = [ "out" "man" "devman" ];
  } ''
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

  install-completion = runTest "install-completion" {} ''
    dd bs=1 count=256 if=/dev/urandom of=foo
    dd bs=1 count=256 if=/dev/urandom of=bar
    dd bs=1 count=256 if=/dev/urandom of=baz
    dd bs=1 count=256 if=/dev/urandom of=qux.zsh
    dd bs=1 count=256 if=/dev/urandom of=quux

    installShellCompletion --bash foo bar --zsh baz qux.zsh --fish quux

    cmp foo $out/share/bash-completion/completions/foo
    cmp bar $out/share/bash-completion/completions/bar
    cmp baz $out/share/zsh/site-functions/_baz
    cmp qux.zsh $out/share/zsh/site-functions/_qux
    cmp quux $out/share/fish/vendor_completions.d/quux
  '';
  install-completion-output = runTest "install-completion-output" {
    outputs = [ "out" "bin" ];
  } ''
    dd bs=1 count=256 if=/dev/urandom of=foo

    installShellCompletion --bash foo

    # assert it didn't go into $out
    [[ ! -f $out/share/bash-completion/completions/foo ]]

    cmp foo ''${!outputBin:?}/share/bash-completion/completions/foo

    touch $out
  '';
  install-completion-name = runTest "install-completion-name" {} ''
    dd bs=1 count=256 if=/dev/urandom of=foo
    dd bs=1 count=256 if=/dev/urandom of=bar
    dd bs=1 count=256 if=/dev/urandom of=baz

    installShellCompletion --bash --name foobar.bash foo --zsh --name _foobar bar --fish baz

    cmp foo $out/share/bash-completion/completions/foobar.bash
    cmp bar $out/share/zsh/site-functions/_foobar
    cmp baz $out/share/fish/vendor_completions.d/baz
  '';
  install-completion-inference = runTest "install-completion-inference" {} ''
    dd bs=1 count=256 if=/dev/urandom of=foo.bash
    dd bs=1 count=256 if=/dev/urandom of=bar.zsh
    dd bs=1 count=256 if=/dev/urandom of=baz.fish

    installShellCompletion foo.bash bar.zsh baz.fish

    cmp foo.bash $out/share/bash-completion/completions/foo.bash
    cmp bar.zsh $out/share/zsh/site-functions/_bar
    cmp baz.fish $out/share/fish/vendor_completions.d/baz.fish
  '';
  install-completion-cmd = runTest "install-completion-cmd" {} ''
    dd bs=1 count=256 if=/dev/urandom of=foo.bash
    dd bs=1 count=256 if=/dev/urandom of=bar.zsh
    dd bs=1 count=256 if=/dev/urandom of=baz.fish
    dd bs=1 count=256 if=/dev/urandom of=qux.fish

    installShellCompletion --cmd foobar --bash foo.bash --zsh bar.zsh --fish baz.fish --name qux qux.fish

    cmp foo.bash $out/share/bash-completion/completions/foobar.bash
    cmp bar.zsh $out/share/zsh/site-functions/_foobar
    cmp baz.fish $out/share/fish/vendor_completions.d/foobar.fish
    cmp qux.fish $out/share/fish/vendor_completions.d/qux
  '';
  install-completion-fifo = runTest "install-completion-fifo" {} ''
    dd bs=1 count=256 if=/dev/urandom of=foo.bash
    dd bs=1 count=256 if=/dev/urandom of=bar.zsh
    dd bs=1 count=256 if=/dev/urandom of=baz.fish

    installShellCompletion \
      --bash --name foo.bash <(cat foo.bash) \
      --zsh --name _foo <(cat bar.zsh) \
      --fish --name foo.fish <(cat baz.fish)

    cmp foo.bash $out/share/bash-completion/completions/foo.bash
    cmp bar.zsh $out/share/zsh/site-functions/_foo
    cmp baz.fish $out/share/fish/vendor_completions.d/foo.fish
  '';
}
