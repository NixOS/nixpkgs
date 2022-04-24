#Adapted from
#https://github.com/rycee/home-manager/blob/2c07829be2bcae55e04997b19719ff902a44016d/home-manager/default.nix

{ bash, coreutils, findutils, gnused, less, ncurses, gettext, nixos-option, lib, stdenv, makeWrapper, fetchFromGitHub }:

stdenv.mkDerivation rec {

  pname = "home-manager";
  version = "2022-04-17";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "home-manager";
    rev = "620ed197f3624dafa5f42e61d5c043f39b8df366";
    sha256 = "sha256-BoBvGT71yOfrNDTZQs7+FX0zb4yjMBETgIjtTsdJw+o=";
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
