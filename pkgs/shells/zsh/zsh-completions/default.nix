{ stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  name = "zsh-completions-${version}";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-completions";
    rev = "${version}";
    sha256 = "02n1svaw74y0za856w8zjb98nzg1h6bmy4xsar71irsk1mj3m5h2";
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
