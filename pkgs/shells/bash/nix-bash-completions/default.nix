{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "0.6.8";
  pname = "nix-bash-completions";

  src = fetchFromGitHub {
    owner = "hedning";
    repo = "nix-bash-completions";
    rev = "v${version}";
    sha256 = "1n5zs6xcnv4bv1hdaypmz7fv4j7dsr4a0ifah99iyj4p5j85i1bc";
  };

  postPatch = ''
    # Nix 2.4+ provides its own completion for the nix command, see https://github.com/hedning/nix-bash-completions/issues/20
    # NixOS provides its own completions for nixos-rebuild now.
    substituteInPlace _nix \
      --replace 'nix nixos-option' 'nixos-option' \
      --replace 'nixos-rebuild nixos-install' 'nixos-install'
  '';

  strictDeps = true;
  # To enable lazy loading via bash-completion we need a symlink to the script
  # from every command name.
  installPhase = ''
    runHook preInstall

    commands=$(
      function complete() { shift 2; echo "$@"; }
      shopt -s extglob
      source _nix
    )
    install -Dm444 -t $out/share/bash-completion/completions _nix
    cd $out/share/bash-completion/completions
    for c in $commands; do
      ln -s _nix $c
    done

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/hedning/nix-bash-completions";
    description = "Bash completions for Nix, NixOS, and NixOps";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ hedning ncfavier ];
    # Set a lower priority such that Nix wins in case of conflicts.
    priority = 10;
  };
}
