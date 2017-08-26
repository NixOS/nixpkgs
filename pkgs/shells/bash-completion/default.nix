{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "bash-completion-${version}";
  version = "2.7";

  src = fetchurl {
    url = "https://github.com/scop/bash-completion/releases/download/${version}/${name}.tar.xz";
    sha256 = "07j484vb3k90f4989xh1g1x99g01akrp69p3dml4lza27wnqkfj1";
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
