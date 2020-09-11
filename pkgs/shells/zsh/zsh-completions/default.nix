{ stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  pname = "zsh-completions";
  version = "0.32.0";

  src = fetchFromGitHub {
    owner = "zsh-users";
    repo = pname;
    rev = version;
    sha256 = "12l9wrx0aysyj62kgp5limglz0nq73w8c415wcshxnxmhyk6sw6d";
  };

  installPhase= ''
    install -D --target-directory=$out/share/zsh/site-functions src/*
  '';

  meta = {
    description = "Additional completion definitions for zsh";
    homepage = "https://github.com/zsh-users/zsh-completions";
    license = stdenv.lib.licenses.free;

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.olejorgenb ];
  };
}
