{ stdenv, fetchgit, pkgconfig, ffmpeg, mesa, nvidia_cg_toolkit
, freetype, libxml2, libv4l, coreutils, python34, which, udev, alsaLib
, libX11, libXext, libXxf86vm, libXdmcp, SDL, pulseaudio ? null }:

stdenv.mkDerivation rec {
  name = "retroarch-bare-${version}";
  version = "20141009";

  src = fetchgit {
    url = git://github.com/libretro/RetroArch.git;
    rev = "72f26dfb49f236294c52eb9cb4c9d5c15da4837a";
    sha256 = "0dn9fh1frnbxykhw3q229ck50a800p8r4va8nssfcdxh8cys385w";
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
