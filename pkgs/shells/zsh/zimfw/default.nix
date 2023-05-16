{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zimfw";
<<<<<<< HEAD
  version = "1.12.0";
=======
  version = "1.11.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "zimfw";
    repo = "zimfw";
    rev = "v${version}";
    ## zim only needs this one file to be installed.
    sparseCheckout = [ "zimfw.zsh" ];
<<<<<<< HEAD
    sha256 = "sha256-PwfPiga4KcOrkkObIu3RCUmO2ExoDQkbQx7S+Yncy6k=";
=======
    sha256 = "sha256-q3OSypjqAc+ul0kF6f3u+wnFyNEm4AKwyPBwQzlVzYU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  strictDeps = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r $src/zimfw.zsh $out/

    runHook postInstall
  '';

  ## zim automates the downloading of any plugins you specify in the `.zimrc`
  ## file. To do that with Nix, you'll need $ZIM_HOME to be writable.
  ## `~/.cache/zim` is a good place for that. The problem is that zim also
  ## looks for `zimfw.zsh` there, so we're going to tell it here to look for
  ## the `zimfw.zsh` where we currently are.
  postFixup = ''
    substituteInPlace $out/zimfw.zsh \
      --replace "\''${ZIM_HOME}/zimfw.zsh" "$out/zimfw.zsh" \
      --replace "\''${(q-)ZIM_HOME}/zimfw.zsh" "$out/zimfw.zsh"
  '';

  meta = with lib; {
    description =
      "The Zsh configuration framework with blazing speed and modular extensions";
    homepage = "https://zimfw.sh";
    license = licenses.mit;
    maintainers = [ maintainers.joedevivo ];
    platforms = platforms.all;
  };
}
