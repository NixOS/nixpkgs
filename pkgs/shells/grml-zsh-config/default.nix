{ stdenv, fetchurl, lib
, zsh, coreutils, inetutils, procps, txt2tags }:

with lib;

stdenv.mkDerivation rec {
  name = "grml-zsh-config-${version}";
  version = "0.12.4";

  src = fetchurl {
    url = "http://deb.grml.org/pool/main/g/grml-etc-core/grml-etc-core_${version}.tar.gz";
    sha256 = "1cbedc41e32787c37c2ed546355a26376dacf2ae1fab9551c9ace3e46d236b72";
  };

  buildInputs = [ zsh coreutils inetutils procps txt2tags ];

  buildPhase = ''
    cd doc
    make
    cd ..
  '';

  installPhase = ''
    install -D -m644 etc/zsh/keephack $out/etc/zsh/keephack
    install -D -m644 etc/zsh/zshrc $out/etc/zsh/zshrc

    install -D -m644 doc/grmlzshrc.5 $out/share/man/man5/grmlzshrc.5
    ln -s grmlzshrc.5.gz $out/share/man/man5/grml-zsh-config.5.gz
  '';

  meta = with stdenv.lib; {
    description = "grml's zsh setup";
    homepage = http://grml.org/zsh/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.msteen ];
  };
}
