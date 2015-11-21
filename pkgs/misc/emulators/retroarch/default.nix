{ stdenv, fetchgit, pkgconfig, ffmpeg, mesa, nvidia_cg_toolkit
, freetype, libxml2, libv4l, coreutils, python34, which, udev, alsaLib
, libX11, libXext, libXxf86vm, libXdmcp, SDL, libpulseaudio ? null }:

stdenv.mkDerivation rec {
  name = "retroarch-bare-${version}";
  version = "2015-11-20";

  src = fetchgit {
    url = https://github.com/libretro/RetroArch.git;
    rev = "09dda14549fc13231311fd522a07a75e923889aa";
    sha256 = "1f7w4i0idc4n0sqc5pcrsxsljk3f614sfdqhdgjb1l4xj16g37cg";
  };

  buildInputs = [ pkgconfig ffmpeg mesa nvidia_cg_toolkit freetype libxml2 libv4l coreutils
                  python34 which udev alsaLib libX11 libXext libXxf86vm libXdmcp SDL libpulseaudio ];

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
    maintainers = with maintainers; [ MP2E edwtjo ];
  };
}
