{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, writeShellScriptBin
, runtimeShell
, installShellFiles
, bc
, ncurses
, perl
, glibcLocales
, testers
, fzf
}:

let
  # on Linux, wrap perl in the bash completion scripts with the glibc locales,
  # so that using the shell completion (ctrl+r, etc) doesn't result in ugly
  # warnings on non-nixos machines
  ourPerl = if !stdenv.isLinux then perl else (
    writeShellScriptBin "perl" ''
      export LOCALE_ARCHIVE="${glibcLocales}/lib/locale/locale-archive"
      exec ${perl}/bin/perl "$@"
    '');
in
buildGoModule rec {
  pname = "fzf";
  version = "0.42.0";

  src = fetchFromGitHub {
    owner = "junegunn";
    repo = pname;
    rev = version;
    hash = "sha256-+65R7cbj62UXw3ZYXIK9VcAeGnpP4pLigr21awoPLi4=";
  };

  vendorHash = "sha256-O6OjBbrVAxDQd27ar2mmFkU1XyVM2C8SJWJ54rgaf2s=";

  CGO_ENABLED = 0;

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ ncurses ];

  ldflags = [
    "-s" "-w" "-X main.version=${version} -X main.revision=${src.rev}"
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
    substituteInPlace shell/key-bindings.bash \
      --replace " perl -n " " ${ourPerl}/bin/perl -n "
    # fzf-tmux depends on bc
   substituteInPlace bin/fzf-tmux \
     --replace "bc" "${bc}/bin/bc"
  '';

  postInstall = ''
    install bin/fzf-tmux $out/bin

    installManPage man/man1/fzf.1 man/man1/fzf-tmux.1

    install -D plugin/* -t $out/share/vim-plugins/${pname}/plugin
    mkdir -p $out/share/nvim
    ln -s $out/share/vim-plugins/${pname} $out/share/nvim/site

    # Install shell integrations
    install -D shell/* -t $out/share/fzf/
    install -D shell/key-bindings.fish $out/share/fish/vendor_functions.d/fzf_key_bindings.fish
    mkdir -p $out/share/fish/vendor_conf.d
    echo fzf_key_bindings > $out/share/fish/vendor_conf.d/load-fzf-key-bindings.fish

    cat <<SCRIPT > $out/bin/fzf-share
    #!${runtimeShell}
    # Run this script to find the fzf shared folder where all the shell
    # integration scripts are living.
    echo $out/share/fzf
    SCRIPT
    chmod +x $out/bin/fzf-share
  '';

  passthru.tests.version = testers.testVersion {
    package = fzf;
  };

  meta = with lib; {
    homepage = "https://github.com/junegunn/fzf";
    description = "A command-line fuzzy finder written in Go";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ma27 zowoq ];
    platforms = platforms.unix;
    changelog = "https://github.com/junegunn/fzf/blob/${version}/CHANGELOG.md";
  };
}
