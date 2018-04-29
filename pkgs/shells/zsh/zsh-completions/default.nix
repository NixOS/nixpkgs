{ stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  name = "zsh-completions-${version}";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-completions";
    rev = "${version}";
    sha256 = "1c2xx9bkkvyy0c6aq9vv3fjw7snlm0m5bjygfk5391qgjpvchd29";
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
