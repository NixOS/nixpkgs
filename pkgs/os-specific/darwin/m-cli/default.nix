{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "m-cli";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "rgcr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KzlE1DdVMLnGmcOS1a2HK4pASofD1EHpdqbzVVIxeb4=";
  };

  dontBuild = true;

  installPhase = ''
    local MPATH="$out/share/m"

    gawk -i inplace '{
      gsub(/^\[ -L.*|^\s+\|\| pushd.*|^popd.*/, "");
      gsub(/MPATH=.*/, "MPATH='$MPATH'");
      gsub(/(update|uninstall)_mcli \&\&.*/, "echo NOOP \\&\\& exit 0");
      print
    }' m

    install -Dt "$MPATH/plugins" -m755 plugins/*

    install -Dm755 m $out/bin/m

    install -Dt "$out/share/bash-completion/completions/" -m444 completion/bash/m
    install -Dt "$out/share/fish/vendor_completions.d/" -m444 completion/fish/m.fish
    install -Dt "$out/share/zsh/site-functions/" -m444 completion/zsh/_m
  '';

  meta = with lib; {
    description = "Swiss Army Knife for macOS";
    inherit (src.meta) homepage;

    license = licenses.mit;

    platforms = platforms.darwin;
    maintainers = [ ];
    mainProgram = "m";
  };
}
