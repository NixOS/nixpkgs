{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "chrpath-0.16";

  src = fetchurl {
    url = "https://alioth.debian.org/frs/download.php/file/3979/chrpath-0.16.tar.gz";
    sha256 = "0yvfq891mcdkf8g18gjjkn2m5rvs8z4z4cl1vwdhx6f2p9a4q3dv";
  };

  meta = with stdenv.lib; {
    description = "Command line tool to adjust the RPATH or RUNPATH of ELF binaries";
    longDescription = ''
      chrpath changes, lists or removes the rpath or runpath setting in a
      binary. The rpath, or runpath if it is present, is where the runtime
      linker should look for the libraries needed for a program.
    '';
    homepage = https://alioth.debian.org/projects/chrpath/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
