{ stdenv, fetchFromGitHub, lib
, zsh, coreutils, inetutils, procps, txt2tags }:

with lib;

stdenv.mkDerivation rec {
  pname = "grml-zsh-config";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "grml";
    repo = "grml-etc-core";
    rev = "v${version}";
    sha256 = "1dmhwgs5v4f1yanbi6dg1lbpzmvq1l3dq7sra811ycsf4f6g0d7f";
  };

  buildInputs = [ zsh coreutils txt2tags procps ]
    ++ optional stdenv.isLinux inetutils;

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
