{ stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  name = "zsh-completions-${version}";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-completions";
    rev = "${version}";
    sha256 = "0iwb1kaidjxaz66kbbdzbydbdlfc6dk21sflzar0zy25jgx1p4xs";
  };

  installPhase= ''
    targetDir=$out/share/zsh/site-functions
    install -D --target-directory=$out/share/zsh/site-functions src/*
  '';

  meta = {
    description = "Additional completion definitions for zsh";
    homepage = "https://github.com/zsh-users/zsh-completions";
    license = "various";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.olejorgenb ];
  };
}
