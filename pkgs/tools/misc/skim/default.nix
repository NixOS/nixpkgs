{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "skim";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "lotabout";
    repo = pname;
    rev = "v${version}";
    sha256 = "06d2mh60qzm62gn06m1b4pvn9wq2jcna2prgzl69alb6fsfdyp7z";
  };

  outputs = [ "out" "vim" ];

  cargoSha256 = "0jypd49cha6fy8dwji7xqp2vsi2as20lk4zymx8z4ifqj0s2qjyb";

  patchPhase = ''
    sed -i -e "s|expand('<sfile>:h:h')|'$out'|" plugin/skim.vim
  '';

  postInstall = ''
    install -D -m 555 bin/sk-tmux -t $out/bin
    install -D -m 644 shell/skim.1 $out/man/man1/skim.1
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
    homepage = https://github.com/lotabout/skim;
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;
  };
}
