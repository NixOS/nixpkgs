{ stdenv, fetchgit, pandoc, ... } :

let
  rev = "287af2b80e0829b08dc6329b4fe8d8e5594d64b0";
in
stdenv.mkDerivation {

  name = "fasd-1.0.1";

  src = fetchgit {
    url = "https://github.com/clvv/fasd.git";
    inherit rev;
    sha256 = "0kv9iyfdf916x0gab9fzs4vmsnkaqmb6kh4xna485nqij89xzkgs";
  };

  installPhase = ''
    PREFIX=$out make install
  '';

  meta = {
    homepage = "https://github.com/clvv/fasd";
    description = "quick command-line access to files and directories for POSIX shells";
    license = "free";

    longDescription = ''
      Fasd is a command-line productivity booster.
      Fasd offers quick access to files and directories for POSIX shells. It is
      inspired by tools like autojump, z and v. Fasd keeps track of files and
      directories you have accessed, so that you can quickly reference them in the
      command line.
    '';

    platforms = stdenv.lib.platforms.all;
  };
}


