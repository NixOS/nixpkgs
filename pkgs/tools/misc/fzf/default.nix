{ lib, buildGoModule, fetchFromGitHub, writeText, runtimeShell, ncurses, }:

buildGoModule rec {
  pname = "fzf";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "junegunn";
    repo = pname;
    rev = version;
    sha256 = "02zy3c4k84rzqdkaf04idbj10v286hi0ix1xl2qsz1wrblh168w8";
  };

  modSha256 = "12lnv8b96adpcg9qfizcyd9nxz590nxd82xch6ij719zlqyps143";

  outputs = [ "out" "man" ];

  fishHook = writeText "load-fzf-keybindings.fish" "fzf_key_bindings";

  buildInputs = [ ncurses ];

  # The vim plugin expects a relative path to the binary; patch it to abspath.
  patchPhase = ''
    sed -i -e "s|expand('<sfile>:h:h')|'$out'|" plugin/fzf.vim

    if ! grep -q $out plugin/fzf.vim; then
        echo "Failed to replace vim base_dir path with $out"
        exit 1
    fi
  '';

  doCheck = true;

  preInstall = ''
    mkdir -p $out/share/fish/{vendor_functions.d,vendor_conf.d}
    cp shell/key-bindings.fish $out/share/fish/vendor_functions.d/fzf_key_bindings.fish
    cp ${fishHook} $out/share/fish/vendor_conf.d/load-fzf-key-bindings.fish
  '';

  postInstall = ''
    cp bin/fzf-tmux $out/bin

    mkdir -p $man/share/man
    cp -r man/man1 $man/share/man

    mkdir -p $out/share/vim-plugins/${pname}
    cp -r plugin $out/share/vim-plugins/${pname}

    cp -R shell $out/share/fzf
    cat <<SCRIPT > $out/bin/fzf-share
    #!${runtimeShell}
    # Run this script to find the fzf shared folder where all the shell
    # integration scripts are living.
    echo $out/share/fzf
    SCRIPT
    chmod +x $out/bin/fzf-share
  '';

  meta = with lib; {
    homepage = "https://github.com/junegunn/fzf";
    description = "A command-line fuzzy finder written in Go";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ma27 ];
    platforms = platforms.unix;
  };
}
