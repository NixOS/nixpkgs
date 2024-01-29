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
  version = "unstable-2024-01-23";

  src = fetchFromGitHub {
    name = "home-manager-source";
    owner = "nix-community";
    repo = "home-manager";
    rev = "3df2a80f3f85f91ea06e5e91071fa74ba92e5084";
    hash = "sha256-J7Bs9LHdZubgNHZ6+eE/7C18lZ1P6S5/zdJSdXFItI4=";
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

    substituteInPlace $out/bin/home-manager \
      --subst-var-by bash "${bash}" \
      --subst-var-by DEP_PATH "${
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
    mainProgram = "home-manager";
  };
})
