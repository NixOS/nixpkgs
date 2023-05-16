<<<<<<< HEAD
{ lib
, stdenvNoCC
, fetchFromGitHub
, bash
, coreutils
, findutils
, gettext
, gnused
, less
, ncurses
, nixos-option
, unixtools
, installShellFiles
, unstableGitUpdater
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "home-manager";
  version = "2023-05-30";

  src = fetchFromGitHub {
    name = "home-manager-source";
    owner = "nix-community";
    repo = "home-manager";
    rev = "54a9d6456eaa6195998a0f37bdbafee9953ca0fb";
    hash = "sha256-pkk3J9gX745LEkkeTGhSRJqPJkmCPQzwI/q7a720XaY=";
  };

  nativeBuildInputs = [
    gettext
    installShellFiles
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D -m755 home-manager/home-manager $out/bin/home-manager
    install -D -m755 lib/bash/home-manager.sh $out/share/bash/home-manager.sh
=======
#Adapted from
#https://github.com/rycee/home-manager/blob/2c07829be2bcae55e04997b19719ff902a44016d/home-manager/default.nix

{ bash, coreutils, findutils, gnused, less, ncurses, gettext, nixos-option, lib, stdenv, makeWrapper, fetchFromGitHub }:

stdenv.mkDerivation rec {

  pname = "home-manager";
  version = "2023-04-02";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "home-manager";
    rev = "ddd8866c0306c48f465e7f48432e6f1ecd1da7f8";
    sha256 = "sha256-+8FUmS4GbDMynQErZGXKg+wU76rq6mI5fprxFXFWKSM=";
  };

  nativeBuildInputs = [ makeWrapper ];
  dontBuild = true;

  installPhase = ''
    install -v -D -m755 ${src}/home-manager/home-manager $out/bin/home-manager
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    substituteInPlace $out/bin/home-manager \
      --subst-var-by bash "${bash}" \
      --subst-var-by DEP_PATH "${
<<<<<<< HEAD
        lib.makeBinPath [
          coreutils
          findutils
          gettext
          gnused
          less
          ncurses
          nixos-option
          unixtools.hostname
        ]
      }" \
      --subst-var-by HOME_MANAGER_LIB '${placeholder "out"}/share/bash/home-manager.sh' \
      --subst-var-by HOME_MANAGER_PATH "${finalAttrs.src}" \
      --subst-var-by OUT '${placeholder "out"}'

    installShellCompletion --bash --name home-manager.bash home-manager/completion.bash
    installShellCompletion --fish --name home-manager.fish home-manager/completion.fish
    installShellCompletion --zsh --name _home-manager home-manager/completion.zsh

    for pofile in home-manager/po/*.po; do
      lang="''${pofile##*/}"
      lang="''${lang%%.*}"
      mkdir -p "$out/share/locale/$lang/LC_MESSAGES"
      msgfmt -o "$out/share/locale/$lang/LC_MESSAGES/home-manager.mo" "$pofile"
    done

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/nix-community/home-manager/";
  };

  meta = {
    homepage = "https://nix-community.github.io/home-manager/";
    description = "A Nix-based user environment configurator";
    longDescription = ''
      The Home-Manager project provides a basic system for managing a user
      environment using the Nix package manager together with the Nix libraries
      found in Nixpkgs. It allows declarative configuration of user specific
      (non global) packages and dotfiles.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
