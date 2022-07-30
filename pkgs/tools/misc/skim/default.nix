{ lib, stdenv, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "skim";
  version = "0.9.4";

  src = fetchCrate {
    inherit pname version;
    sha256 = "0yvjzmz2vqc63l8911jflqf5aww7wxsav2yal5wg9ci9hzq6dl7j";
  };

  shells = [ "bash" "fish" "zsh" ];
  outputs = [ "out" "vim" ] ++ (map (sh:"interactiveShellInit_${sh}") shells);

  cargoSha256 = "1jk2vcm2z6r1xd6md98jzpcy7kdwp5p2fzxvvaz9qscyfnx28x17";

  postPatch = ''
    sed -i -e "s|expand('<sfile>:h:h')|'$out'|" plugin/skim.vim
  '';

  postInstall = ''
    install -D -m 555 bin/sk-tmux -t $out/bin
    install -D -m 644 man/man1/* -t $out/man/man1
    install -D -m 444 shell/* -t $out/share/skim
    install -D -m 444 plugin/skim.vim -t $vim/plugin

    cat <<SCRIPT > $out/bin/sk-share
    #! ${stdenv.shell}
    # Run this script to find the skim shared folder where all the shell
    # integration scripts are living.
    echo $out/share/skim
    SCRIPT
    chmod +x $out/bin/sk-share

    (
      echo 'if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then'
      cat $out/share/skim/{completion,key-bindings}.bash
      echo fi
    ) > $interactiveShellInit_bash
    (
      echo 'if [[ $options[zle] = on ]]; then'
      cat $out/share/skim/{completion,key-bindings}.zsh
      echo fi
    ) > $interactiveShellInit_zsh
    (
      cat $out/share/skim/key-bindings.fish
      echo skim_key_bindings
    ) > $interactiveShellInit_fish
  '';

  # https://github.com/lotabout/skim/issues/440
  doCheck = !stdenv.isAarch64;

  meta = with lib; {
    description = "Command-line fuzzy finder written in Rust";
    homepage = "https://github.com/lotabout/skim";
    license = licenses.mit;
    mainProgram = "sk";
    maintainers = with maintainers; [ dywedir ];
  };
}
