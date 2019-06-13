{ stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  name = "zsh-completions-${version}";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-completions";
    rev = "${version}";
    sha256 = "1yf4rz99acdsiy0y1v3bm65xvs2m0sl92ysz0rnnrlbd5amn283l";
  };

  installPhase= ''
    install -D --target-directory=$out/share/zsh/site-functions src/*
  '';

  meta = {
    description = "Additional completion definitions for zsh";
    homepage = https://github.com/zsh-users/zsh-completions;
    license = stdenv.lib.licenses.free;

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.olejorgenb ];
  };
}
