{ stdenv, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "skim";
  version = "0.9.3";

  src = fetchCrate {
    inherit pname version;
    sha256 = "026mgqcp9sg6wwikghrc3rgh5p6wdbnvav5pb3xvs79lj85d5ga7";
  };

  outputs = [ "out" "vim" ];

  cargoSha256 = "07bs23x2vxzlrca5swwq8khmd9fbdhlhm0avwp9y231df6xdi2ys";

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
