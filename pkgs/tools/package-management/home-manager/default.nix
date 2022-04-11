#Adapted from
#https://github.com/rycee/home-manager/blob/2c07829be2bcae55e04997b19719ff902a44016d/home-manager/default.nix

{ bash, coreutils, findutils, gnused, less, ncurses, gettext, nixos-option, lib, stdenv, makeWrapper, fetchFromGitHub }:

stdenv.mkDerivation rec {

  pname = "home-manager";
  version = "2021-12-25";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "home-manager";
    rev = "48f2b381dd397ec88040d3354ac9c036739ba139";
    sha256 = "1i9v94brh9vhyhzcqyfj64nzhaibdj0sw74pxgk4bcsp0hqawgcd";
  };

  nativeBuildInputs = [ makeWrapper ];
  dontBuild = true;

  installPhase = ''
    install -v -D -m755 ${src}/home-manager/home-manager $out/bin/home-manager

    substituteInPlace $out/bin/home-manager \
      --subst-var-by bash "${bash}" \
      --subst-var-by DEP_PATH "${
        lib.makeBinPath [ coreutils findutils gettext gnused less ncurses nixos-option ]
      }" \
      --subst-var-by HOME_MANAGER_LIB '${src}/lib/bash/home-manager.sh' \
      --subst-var-by HOME_MANAGER_PATH '${src}' \
      --subst-var-by OUT "$out"

    install -D -m755 ${src}/home-manager/completion.bash \
      $out/share/bash-completion/completions/home-manager
    install -D -m755 ${src}/home-manager/completion.zsh \
      $out/share/zsh/site-functions/_home-manager
    install -D -m755 ${src}/home-manager/completion.fish \
      $out/share/fish/vendor_completions.d/home-manager.fish

    install -D -m755 ${src}/lib/bash/home-manager.sh \
      "$out/share/bash/home-manager.sh"

    for path in ${src}/home-manager/po/*.po; do
      lang="''${path##*/}"
      lang="''${lang%%.*}"
      mkdir -p "$out/share/locale/$lang/LC_MESSAGES"
      ${gettext}/bin/msgfmt -o "$out/share/locale/$lang/LC_MESSAGES/home-manager.mo" "$path"
    done
  '';

  meta = with lib; {
    description = "A user environment configurator";
    homepage = "https://rycee.gitlab.io/home-manager/";
    platforms = platforms.unix;
    license = licenses.mit;
  };

}
