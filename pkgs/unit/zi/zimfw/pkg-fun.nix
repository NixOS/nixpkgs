{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zimfw";
  version = "1.11.0";
  src = fetchFromGitHub {
    owner = "zimfw";
    repo = "zimfw";
    rev = "v${version}";
    ## zim only needs this one file to be installed.
    sparseCheckout = [ "zimfw.zsh" ];
    sha256 = "sha256-BmzYAgP5Z77VqcpAB49cQLNuvQX1qcKmAh9BuXsy2pA=";
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
      --replace "\''${ZIM_HOME}/zimfw.zsh" "$out/zimfw.zsh"
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
