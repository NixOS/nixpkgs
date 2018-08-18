{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "skim-${version}";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "lotabout";
    repo = "skim";
    rev = "v${version}";
    sha256 = "0hk19mqfmrsyx28lb8h1hixivl6zrc8dg3imygk1ppgn66c0zf00";
  };

  outputs = [ "out" "vim" ];

  cargoSha256 = "18lgjh1b1wfm9xsd6y6slfj1i3dwrvzkzszdzk3lmqx1f8515gx7";

  patchPhase = ''
    sed -i -e "s|expand('<sfile>:h:h')|'$out'|" plugin/skim.vim
    # fix Cargo.lock version
    sed -i -e '168s|0.4.0|0.5.0|' Cargo.lock
  '';

  postInstall = ''
    install -D -m 555 bin/sk-tmux -t $out/bin
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
    description = "Fuzzy Finder in rust!";
    homepage = https://github.com/lotabout/skim;
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;
  };
}
