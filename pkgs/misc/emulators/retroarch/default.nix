{ stdenv, fetchgit, pkgconfig, ffmpeg, mesa, nvidia_cg_toolkit
, freetype, libxml2, libv4l, coreutils, python34, which, udev, alsaLib
, libX11, libXext, libXxf86vm, libXdmcp, SDL, pulseaudio ? null }:

stdenv.mkDerivation rec {
  name = "retroarch-bare-${version}";
  version = "20141109";

  src = fetchgit {
    url = git://github.com/libretro/RetroArch.git;
    rev = "88b21b87e7554860f4b252bc59ac99fa4032393e";
    sha256 = "0w2diklpv7wl6bmdw4msn90qn7f650q789crdawn63nbqg0rj8a2";
  };

  buildInputs = [ pkgconfig ffmpeg mesa nvidia_cg_toolkit freetype libxml2 libv4l coreutils
                  python34 which udev alsaLib libX11 libXext libXxf86vm libXdmcp SDL pulseaudio ];

  patchPhase = ''
    export GLOBAL_CONFIG_DIR=$out/etc
    sed -e 's#/bin/true#${coreutils}/bin/true#' -i qb/qb.libs.sh
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://libretro.org/;
    description = "Multi-platform emulator frontend for libretro cores";
    license = licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with maintainers; [ MP2E ];
  };
}
