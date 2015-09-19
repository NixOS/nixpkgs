{ stdenv, wine, fetchurl, asiosdk, system, ed, libjack2 } :

# TODO:
# - Wine should use ASIO for audio, see audio tab in winecfg.
#   To switch audio to ASIO edit registry HKEY_CURRENT_USER\Software\Wine\Drivers,
#   Add entry 'Audio=alsa'.
# - Wine can't find wineasio.dll.so, users need to put this in $wine/lib/wine
#   but users should not have to do this.
# - When running: ??????
# Cannot create thread res = 11
# JackMessageBuffer::Create cannot start thread
# Cannot create message buffer
# Cannot create thread res = 11
# Cannot start Jack client listener
# Cannot start channel

stdenv.mkDerivation rec {
  name = "wineasio-0.9.2";
  src = fetchurl {
      url = "mirror://sourceforge/wineasio/${name}.tar.gz";
      sha256 = "02xgj9yr03yqy600m93ds4j491kwi0mxigjq0pf0ghyflh82vg4z";
  };
  buildInputs = [ wine asiosdk ed libjack2 ];
  preBuild = ''
    cp ${asiosdk}/common/asio.h .
    ln -s ${wine}/include/wine ${wine}/include/wine/windows .
    #${if system == "x86_64-linux" then "./prepare_64bit_asio" else ""}
  '';
  makeFlags = [
    (if system == "x86_64-linux" then "-f Makefile64" else "")
    # Prefix is only set to find include files
   "PREFIX=${wine}"
  ];
  installPhase = ''
    mkdir -p $out/lib/wine/
    cp wineasio.dll.so $out/lib/wine/
  '';
  meta = {
    description = "ASIO driver for WINE";
    license = stdenv.lib.licenses.lgpl21;
    homepage = http://sourceforge.net/projects/wineasio/;
    maintainers = with stdenv.lib.maintainers; [ joelmo ];
    hydraPlatforms = [];
  };
}
