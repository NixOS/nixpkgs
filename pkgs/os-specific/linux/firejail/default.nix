{stdenv, fetchurl, which}:
let
  s = # Generated upstream information
  rec {
    baseName="firejail";
    version="0.9.44.8";
    name="${baseName}-${version}";
    hash="0w87n5qzvylbjipaf45sw65gg4rpqcbi32zw9cs1jbfvf4bikzmr";
    url="https://netix.dl.sourceforge.net/project/firejail/firejail/firejail-0.9.44.8.tar.xz";
    sha256="0w87n5qzvylbjipaf45sw65gg4rpqcbi32zw9cs1jbfvf4bikzmr";
  };
  buildInputs = [
    which
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
    name = "${s.name}.tar.bz2";
  };

  preConfigure = ''
    sed -e 's@/bin/bash@${stdenv.shell}@g' -i $( grep -lr /bin/bash .)
    sed -e "s@/bin/cp@$(which cp)@g" -i $( grep -lr /bin/cp .)
  '';

  preBuild = ''
    sed -e "s@/etc/@$out/etc/@g" -i Makefile
  '';

  meta = {
    inherit (s) version;
    description = ''Namespace-based sandboxing tool for Linux'';
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = "http://l3net.wordpress.com/projects/firejail/";
    downloadPage = "http://sourceforge.net/projects/firejail/files/firejail/";
  };
}
