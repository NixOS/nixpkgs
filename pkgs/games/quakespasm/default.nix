{ lib, stdenv, SDL, fetchurl, gzip, libvorbis, libmad }:

stdenv.mkDerivation rec {
  pname = "quakespasm";
  majorVersion = "0.93";
  version = "${majorVersion}.2";

  src = fetchurl {
    url = "mirror://sourceforge/quakespasm/quakespasm-${version}.tgz";
    sha256 = "0qm0j5drybvvq8xadfyppkpk3rxqsxbywzm6iwsjwdf0iia3gss5";
  };

  sourceRoot = "${pname}-${version}/Quake";

  buildInputs = [
    gzip SDL libvorbis libmad
  ];

  buildFlags = [ "DO_USERDIRS=1" ];

  preInstall = ''
    mkdir -p "$out/bin"
    substituteInPlace Makefile --replace "/usr/local/games" "$out/bin"
  '';

  enableParallelBuilding = true;

  meta = with lib; {
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

    platforms = platforms.linux;
    maintainers = with maintainers; [ m3tti ];
  };
}
