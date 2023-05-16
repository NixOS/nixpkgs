{ stdenv, fetchFromGitHub, lib
, zsh, coreutils, inetutils, procps, txt2tags }:

with lib;

stdenv.mkDerivation rec {
  pname = "grml-zsh-config";
<<<<<<< HEAD
  version = "0.19.6";
=======
  version = "0.19.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "grml";
    repo = "grml-etc-core";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-31BD5jUA54oLSsL4NzGaGAiOXMcZwy7uX65pD+jtE4M=";
=======
    sha256 = "sha256-/phoIi8amqdO+OK26+CE2OXwHTE71PaV9NIXEnGl6Co=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  strictDeps = true;
  nativeBuildInputs = [ txt2tags ];
  buildInputs = [ zsh coreutils procps ]
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

  meta = with lib; {
    description = "grml's zsh setup";
    homepage = "https://grml.org/zsh/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ msteen rvolosatovs ];
  };
}
