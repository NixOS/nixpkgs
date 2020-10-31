{ stdenv, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "skim";
  version = "0.9.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "0k101ymr6shi8hivf7kv52vwgcad2dwhyma0yg2pnp9q3ll0iszb";
  };

  outputs = [ "out" "vim" ];

  cargoSha256 = "0b4pj30w07p67zvpn5af23ddkvknmfp5a33sy6ai8argfi73bf4c";

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
