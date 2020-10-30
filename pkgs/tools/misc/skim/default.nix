{ stdenv, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "skim";
  version = "0.9.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "1r8zf56kb9rhh8nlh8w684srr8jfhndf8742x8byw374my9xn8pb";
  };

  outputs = [ "out" "vim" ];

  cargoSha256 = "0wjlkyngrc03a92fwmavgj90h0kakww38bfc1wapn2my7p3b6nc1";

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
  '';

  meta = with stdenv.lib; {
    description = "Command-line fuzzy finder written in Rust";
    homepage = "https://github.com/lotabout/skim";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
  };
}
