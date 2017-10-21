{ stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  name = "zsh-completions-${version}";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-completions";
    rev = "${version}";
    sha256 = "16yhwf42a11v8bhnfb7nda0svxmglzph3c0cknvf8p5m6mkqj9s2";
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
