{ stdenv, fetchgit, pkgconfig, ffmpeg, mesa, nvidia_cg_toolkit
, freetype, libxml2, libv4l, coreutils, python34, which, udev, alsaLib
, libX11, libXext, libXxf86vm, libXdmcp, SDL, pulseaudio ? null }:

stdenv.mkDerivation rec {
  name = "retroarch-bare-${version}";
  version = "20140902";

  src = fetchgit {
    url = git://github.com/libretro/RetroArch.git;
    rev = "0856091296c2e47409f36e13007805d71db69483";
    sha256 = "152dfp6jd7yzvasqrqw4ydjbdcwq4khisia2dax3gydvxkq87nl4";
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
    maintainers = with maintainers; [ MP2E ];
  };
}
