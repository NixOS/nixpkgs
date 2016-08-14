{ stdenv, fetchFromGitHub } :

stdenv.mkDerivation rec {
  pname = "fasd";
  name = "${pname}-unstable-2016-08-11";

  src = fetchFromGitHub {
    owner = "clvv";
    repo = "${pname}";
    rev = "90b531a5daaa545c74c7d98974b54cbdb92659fc";
    sha256 = "0i22qmhq3indpvwbxz7c472rdyp8grag55x7iyjz8gmyn8gxjc11";
  };

  installPhase = ''
    PREFIX=$out make install
  '';

  meta = {
    homepage = "https://github.com/clvv/${pname}";
    description = "Quick command-line access to files and directories for POSIX shells";
    license = stdenv.lib.licenses.mit;

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
