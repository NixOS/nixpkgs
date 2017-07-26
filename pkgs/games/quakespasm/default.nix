{ stdenv, SDL, fetchurl, gzip, libvorbis, libmad }:
stdenv.mkDerivation rec {
  name = "quakespasm-${version}";
  majorVersion = "0.92";
  version = "${majorVersion}.1";

  src = fetchurl {
    url = "mirror://sourceforge/quakespasm/quakespasm-${version}.tgz";
    sha256 = "0vhycjg97sn4cd85ph6qz68rplzrm4apijdkrlj9mycnqjv5l100";
  };

  sourceRoot = "${name}/Quake";
  
  buildInputs = [
    gzip SDL libvorbis libmad
  ];

  preInstall = ''
    mkdir -p "$out/bin"
    substituteInPlace Makefile --replace "/usr/local/games" "$out/bin"
  '';

  enableParallelBuilding = true;
  
  meta = {
    description = "An engine for iD software's Quake";
    homepage = "http://quakespasm.sourceforge.net/";
    longDescription = ''
      QuakeSpasm is a modern, cross-platform Quake 1 engine based on FitzQuake.
      It includes support for 64 bit CPUs and custom music playback, a new sound driver, 
      some graphical niceities, and numerous bug-fixes and other improvements.
      Quakespasm utilizes either the SDL or SDL2 frameworks, so choose which one 
      works best for you. SDL is probably less buggy, but SDL2 has nicer features 
      and smoother mouse input - though no CD support.
    '';
  
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.m3tti ];
  };
}
