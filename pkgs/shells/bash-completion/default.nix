{ stdenv, fetchurl }:

let
  version = "2.0";
in
stdenv.mkDerivation {
  name = "bash-completion-${version}";

  src = fetchurl {
    url = "http://bash-completion.alioth.debian.org/files/bash-completion-${version}.tar.bz2";
    sha256 = "e5a490a4301dfb228361bdca2ffca597958e47dd6056005ef9393a5852af5804";
  };

  doCheck = true;

  meta = {
    homepage = "http://bash-completion.alioth.debian.org/";
    description = "Programmable completion for the bash shell";
    license = "GPL";

    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
