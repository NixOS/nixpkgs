{ stdenv, fetchFromGitHub, lib
, zsh, coreutils, inetutils, procps, txt2tags }:

with lib;

stdenv.mkDerivation rec {
  name = "grml-zsh-config-${version}";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "grml";
    repo = "grml-etc-core";
    rev = "v${version}";
    sha256 = "13mm1vjmb600l4g0ssr56xrlx6lwpv1brrpmf2v2pp2d5ki0d47x";
  };

  buildInputs = [ zsh coreutils txt2tags procps ]
    ++ optional stdenv.isLinux [ inetutils ];

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
    platforms = platforms.unix;
    maintainers = with maintainers; [ msteen rvolosatovs ];
  };
}
