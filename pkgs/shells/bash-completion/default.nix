{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "bash-completion-${version}";
  version = "2.5";

  src = fetchurl {
    url = "https://github.com/scop/bash-completion/releases/download/${version}/${name}.tar.xz";
    sha256 = "1kwmii1z1ljx5i4z702ynsr8jgrq64bj9w9hl3n2aa2kcl659fdh";
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
