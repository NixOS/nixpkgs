{ stdenv, fetchgit, pkgconfig, ffmpeg, mesa, nvidia_cg_toolkit
, freetype, libxml2, libv4l, coreutils, python34, which, udev, alsaLib
, libX11, libXext, libXxf86vm, libXdmcp, SDL, pulseaudio ? null }:

stdenv.mkDerivation rec {
  name = "retroarch-bare-${version}";
  version = "20141224";

  src = fetchgit {
    url = git://github.com/libretro/RetroArch.git;
    rev = "8b4176263988e750daf0c6d709fdceb4672e111e";
    sha256 = "1l2iqgb7vlkh6kcwr4ggcn58ldyh63v9zvjmv26z8pxiqa1zr1xs";
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
