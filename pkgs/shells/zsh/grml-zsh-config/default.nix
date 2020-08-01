{ stdenv, fetchFromGitHub, lib
, zsh, coreutils, inetutils, procps, txt2tags }:

with lib;

stdenv.mkDerivation rec {
  pname = "grml-zsh-config";
  version = "0.17.4";

  src = fetchFromGitHub {
    owner = "grml";
    repo = "grml-etc-core";
    rev = "v${version}";
    sha256 = "09c3f7s2r0cb8g9kgh3xhc8dhr1656g1q9s9i3s5imvknwqii6as";
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
    homepage = "http://grml.org/zsh/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ msteen rvolosatovs ];
  };
}
