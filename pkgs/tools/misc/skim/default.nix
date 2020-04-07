{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "skim";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "lotabout";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xjb8slrlkrzdqvzmf63lq6rgggrjw3hf9an6h8xf6vizz1vfni0";
  };

  outputs = [ "out" "vim" ];

  cargoSha256 = "14p4ppbl2mak21jvxpbd1b28jaw2629bc8kv7875cdzy3ksxyji3";

  patchPhase = ''
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
    platforms = platforms.all;
  };
}
