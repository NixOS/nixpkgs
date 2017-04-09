{ stdenv, fetchFromGitHub, makeWrapper, lrzsz }:

stdenv.mkDerivation rec {
  name = "picocom-${version}";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "npat-efault";
    repo = "picocom";
    rev = version;
    sha256 = "06b2ic34dnxc73cprc5imi3iamlhsv623sbg9vj5h5rvs586dwjx";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp picocom $out/bin
    cp picocom.1 $out/share/man/man1

    wrapProgram $out/bin/picocom \
      --prefix PATH ":" "${lrzsz}/bin"
  '';

  meta = {
    description = "Minimal dumb-terminal emulation program";
    homepage = https://github.com/npat-efault/picocom/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
