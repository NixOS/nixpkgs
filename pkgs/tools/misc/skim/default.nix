{ lib
, stdenv
, fetchCrate
, rustPlatform
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "skim";
  version = "0.10.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-C2yK+SO8Tpw3BxXXu1jeDzYJ2548RZa7NFWaE0SdNJ0=";
  };

  nativeBuildInputs = [ installShellFiles ];

  outputs = [ "out" "vim" ];

  cargoHash = "sha256-jBcgoWbmBOgU7M71lr4OXOe2S6NAXl+I8D+ZtT45Vos=";

  postPatch = ''
    sed -i -e "s|expand('<sfile>:h:h')|'$out'|" plugin/skim.vim
  '';

  postInstall = ''
    install -D -m 555 bin/sk-tmux -t $out/bin

    install -D -m 444 plugin/skim.vim -t $vim/plugin

    install -D -m 444 shell/* -t $out/share/skim

    installManPage man/man1/*

    cat <<SCRIPT > $out/bin/sk-share
    #! ${stdenv.shell}
    # Run this script to find the skim shared folder where all the shell
    # integration scripts are living.
    echo $out/share/skim
    SCRIPT
    chmod +x $out/bin/sk-share
  '';

  # https://github.com/lotabout/skim/issues/440
  doCheck = !stdenv.hostPlatform.isAarch64;

  meta = with lib; {
    description = "Command-line fuzzy finder written in Rust";
    homepage = "https://github.com/lotabout/skim";
    license = licenses.mit;
    mainProgram = "sk";
    maintainers = with maintainers; [ dywedir ];
  };
}
