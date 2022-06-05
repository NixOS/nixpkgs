{ stdenv, lib, fetchFromGitHub, chruby }:

stdenv.mkDerivation rec {
  pname = "chruby-fish";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "JeanMertz";
    repo = "chruby-fish";
    rev = "v${version}";
    sha256 = "15q0ywsn9pcypbpvlq0wb41x4igxm9bsvhg9a05dqw1n437qjhyb";
  };

  postInstall = ''
    sed -i -e '1iset CHRUBY_ROOT ${chruby}' $out/share/chruby/auto.fish
    sed -i -e '1iset CHRUBY_ROOT ${chruby}' $out/share/chruby/chruby.fish
  '';

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Thin wrapper around chruby to make it work with the Fish shell";
    homepage = "https://github.com/JeanMertz/chruby-fish";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.cohei ];
  };
}
