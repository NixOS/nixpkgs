{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "bash-completion-${version}";
  version = "2.8";

  src = fetchurl {
    url = "https://github.com/scop/bash-completion/releases/download/${version}/${name}.tar.xz";
    sha256 = "0kgmflrr1ga9wfk770vmakna3nj46ylb5ky9ipd0v2k9ymq5a7y0";
  };

  doCheck = true;

  prePatch = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i -e 's/readlink -f/readlink/g' bash_completion completions/*
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/scop/bash-completion;
    description = "Programmable completion for the bash shell";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.peti ];
  };
}
