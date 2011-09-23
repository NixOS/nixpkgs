{ stdenv, fetchurl }:

let
  version = "1.3";
in
stdenv.mkDerivation {
  name = "bash-completion-${version}";

  src = fetchurl {
    url = "http://bash-completion.alioth.debian.org/files/bash-completion-${version}.tar.bz2";
    sha256 = "8ebe30579f0f3e1a521013bcdd183193605dab353d7a244ff2582fb3a36f7bec";
  };

  postInstall = ''
    rm $out/etc/profile.d/bash_completion.sh
    rmdir $out/etc/profile.d
    sed -i -e "s|/etc/bash_completion|$out/etc/bash_completion|g" $out/etc/bash_completion
  '';

  meta = {
    homepage = "http://bash-completion.alioth.debian.org/";
    description = "Programmable completion for the bash shell";
    license = "GPL";

    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
