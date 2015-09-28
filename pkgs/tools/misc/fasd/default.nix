{ stdenv, fetchgit } :

let
  rev = "61ce53be996189e1c325916e45a7dc0aa89660e3";
in
stdenv.mkDerivation {

  name = "fasd-git-2015-03-29";

  src = fetchgit {
    url = "https://github.com/clvv/fasd.git";
    inherit rev;
    sha256 = "1fd36ff065ae73de2d6b1bae2131c18c8c4dea98ca63d96b0396e8b291072b5e";
  };

  installPhase = ''
    PREFIX=$out make install
  '';

  meta = {
    homepage = "https://github.com/clvv/fasd";
    description = "Quick command-line access to files and directories for POSIX shells";
    license = stdenv.lib.licenses.free; # https://github.com/clvv/fasd/blob/master/LICENSE

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
