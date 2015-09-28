{stdenv, fetchurl, pkgconfig, pcre, libxml2, sqlite, ffmpeg, imagemagick,
exiv2, mp4v2, lame, libvorbis, flac, libmad, faad2}:

stdenv.mkDerivation rec {
  name = "fuppes-0.660";
  src = fetchurl {
    url = mirror://sourceforge/project/fuppes/fuppes/SVN-660/fuppes-0.660.tar.gz;
    sha256 = "1c385b29878927e5f1e55ae2c9ad284849d1522d9517a88e34feb92bd5195173";
  };

  patches = [
    ./fuppes-faad-exanpse-backward-symbols-macro.patch
  ];

  buildInputs = [
    pkgconfig pcre libxml2 sqlite ffmpeg imagemagick exiv2 mp4v2 lame
    libvorbis flac libmad faad2
  ];

  configureFlags = [
    "--enable-ffmpegthumbnailer"
    "--enable-magickwand"
    "--enable-exiv2"
    "--enable-transcoder-ffmpeg"
    "--enable-mp4v2"
    "--enable-lame"
    "--enable-vorbis"
    "--enable-flac"
    "--enable-mad"
    "--enable-faad"
  ];

  postFixup = ''
    patchelf --set-rpath "$(patchelf --print-rpath $out/bin/fuppes):${faad2}/lib" $out/bin/fuppes
    patchelf --set-rpath "$(patchelf --print-rpath $out/bin/fuppesd):${faad2}/lib" $out/bin/fuppesd
  '';

  meta = {
    description = "UPnP A/V Media Server";
    longDescription = ''
      FUPPES is a free, multiplatform UPnP A/V Media Server.

      FUPPES supports a wide range of UPnP MediaRenderers as well as
      on-the-fly transcoding of various audio, video and image formats.

      FUPPES also includes basic DLNA support.
    '';
    homepage = http://fuppes.ulrich-voelkel.de/;
    license = stdenv.lib.licenses.gpl2;

    maintainers = [ stdenv.lib.maintainers.pierron ];
    platforms = stdenv.lib.platforms.all;

    broken = true;
  };
}
