{ lib, buildGoModule, fetchFromGitHub, writeText, runtimeShell, ncurses, perl, fetchpatch }:

buildGoModule rec {
  pname = "fzf";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "junegunn";
    repo = pname;
    rev = version;
    sha256 = "1j5bfxl4w8w3n89p051y8dhxg0py9l98v7r2gkr63bg4lj32faz8";
  };

  vendorSha256 = "0dd0qm1fxp3jnlrhfaas8fw87cj7rygaac35a9nk3xh2xsk7q35p";

  outputs = [ "out" "man" ];

  patches = [
    # Fix test failure on go 1.15
    (fetchpatch {
      url = "https://github.com/junegunn/fzf/commit/82791f7efccde5b30da0b4d44f10d214ae5c0c0d.patch";
      sha256 = "1nybsz09h8cnvxjnkmx9c52g8z0x6pvrn230hw1va5a3pvmg01z1";
    })
  ];

  fishHook = writeText "load-fzf-keybindings.fish" "fzf_key_bindings";

  buildInputs = [ ncurses ];

  buildFlagsArray = [
    "-ldflags=-s -w -X main.version=${version} -X main.revision=${src.rev}"
  ];

  # The vim plugin expects a relative path to the binary; patch it to abspath.
  postPatch = ''
    sed -i -e "s|expand('<sfile>:h:h')|'$out'|" plugin/fzf.vim

    if ! grep -q $out plugin/fzf.vim; then
        echo "Failed to replace vim base_dir path with $out"
        exit 1
    fi

    # Has a sneaky dependency on perl
    # Include first args to make sure we're patching the right thing
    substituteInPlace shell/key-bindings.zsh \
      --replace " perl -ne " " ${perl}/bin/perl -ne "
    substituteInPlace shell/key-bindings.bash \
      --replace " perl -n " " ${perl}/bin/perl -n "
  '';

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
    maintainers = with maintainers; [ Br1ght0ne ma27 zowoq ];
    platforms = platforms.unix;
  };
}
