{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "m-cli";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "rgcr";
    repo = "m-cli";
    rev = "v${version}";
    sha512 = "0mkcx7jq91pbfs8327qc8434gj73fvjgdfdsrza0lyd9wns6jhsqsf0585klzl68aqscvksgzi2asdnim4va35cdkp2fdzl0g3sm4kd";
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

  meta = with stdenv.lib; {
    description = "Swiss Army Knife for macOS";
    inherit (src.meta) homepage;
    repositories.git = git://github.com/rgcr/m-cli.git;

    license = licenses.mit;

    platforms = platforms.darwin;
    maintainers = with maintainers; [ yurrriq ];
  };
}
