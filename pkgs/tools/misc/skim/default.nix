{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "skim";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "lotabout";
    repo = pname;
    rev = "v${version}";
    sha256 = "0paxrf03rqzahbpr4gnsj62vl09vcxvw248n9wzhjq14dqlwcr9w";
  };

  outputs = [ "out" "vim" ];

  cargoSha256 = "0rxxdad60fpwkb4wx5407ihd89wqpf2ldcnp7nsx17xh4brp1l9r";

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
    platforms = platforms.all;
  };
}
