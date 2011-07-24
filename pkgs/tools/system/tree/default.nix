{stdenv, fetchurl}:

let
  version = "1.6.0";
in
stdenv.mkDerivation {
  name = "tree-${version}";

  src = fetchurl {
    url = "http://mama.indstate.edu/users/ice/tree/src/tree-${version}.tgz";
    sha256 = "4dc470a74880338b01da41701d8db90d0fb178877e526d385931a007d68d7591";
  };

  configurePhase = ''
    makeFlagsArray=(
      prefix=$out
      MANDIR=$out/share/man/man1
    )
  '';

  meta = {
    homepage = "http://mama.indstate.edu/users/ice/tree/";
    description = "command to produce a depth indented directory listing";
    license = "GPLv2";

    longDescription = ''
      Tree is a recursive directory listing command that produces a
      depth indented listing of files, which is colorized ala dircolors if
      the LS_COLORS environment variable is set and output is to tty.
    '';

    platforms = stdenv.lib.platforms.unix;
    maintainers = [stdenv.lib.maintainers.simons];
  };
}
