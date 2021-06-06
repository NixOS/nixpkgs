{ lib, stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  pname = "zsh-completions";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "zsh-users";
    repo = pname;
    rev = version;
    sha256 = "0vs14n29wvkai84fvz3dz2kqznwsq2i5fzbwpv8nsfk1126ql13i";
  };

  installPhase= ''
    install -D --target-directory=$out/share/zsh/site-functions src/*
  '';

  meta = {
    description = "Additional completion definitions for zsh";
    homepage = "https://github.com/zsh-users/zsh-completions";
    license = lib.licenses.free;

    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.olejorgenb ];
  };
}
