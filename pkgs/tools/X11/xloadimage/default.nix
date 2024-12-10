{
  lib,
  stdenv,
  fetchurl,
  libX11,
  libXt,

  libjpeg ? null,
  libpng ? null,
  libtiff ? null,

  withJpegSupport ? true,
  withPngSupport ? true,
  withTiffSupport ? true,
}:

assert withJpegSupport -> libjpeg != null;
assert withPngSupport -> libpng != null;
assert withTiffSupport -> libtiff != null;

let
  deb_patch = "25";
in
stdenv.mkDerivation rec {
  version = "4.1";
  pname = "xloadimage";

  src = fetchurl {
    url = "mirror://debian/pool/main/x/xloadimage/xloadimage_${version}.orig.tar.gz";
    sha256 = "1i7miyvk5ydhi6yi8593vapavhwxcwciir8wg9d2dcyg9pccf2s0";
  };

  patches = fetchurl {
    url = "mirror://debian/pool/main/x/xloadimage/xloadimage_${version}-${deb_patch}.debian.tar.xz";
    sha256 = "17k518vrdrya5c9dqhpmm4g0h2vlkq1iy87sg2ngzygypbli1xvn";
  };

  buildInputs =
    [
      libX11
      libXt
    ]
    ++ lib.optionals withJpegSupport [
      libjpeg
    ]
    ++ lib.optionals withPngSupport [
      libpng
    ]
    ++ lib.optionals withTiffSupport [
      libtiff
    ];

  # NOTE: we patch the build-info script so that it never detects the utilities
  # it's trying to find; one of the Debian patches adds support for
  # $SOURCE_DATE_EPOCH, but we want to make sure we don't even call these.
  preConfigure = ''
    substituteInPlace build-info \
      --replace '[ -x /bin/date ]' 'false' \
      --replace '[ -x /bin/id ]' 'false' \
      --replace '[ -x /bin/uname ]' 'false' \
      --replace '[ -x /usr/bin/id ]' 'false'

    chmod +x build-info configure
  '';

  enableParallelBuilding = true;

  # NOTE: we're not installing the `uufilter` binary; if needed, the standard
  # `uudecode` tool should work just fine.
  installPhase = ''
    install -Dm755 xloadimage $out/bin/xloadimage
    ln -sv $out/bin/{xloadimage,xsetbg}

    install -D -m644 xloadimagerc $out/etc/xloadimagerc.example
    install -D -m644 xloadimage.man $out/share/man/man1/xloadimage.1x
    ln -sv $out/share/man/man1/{xloadimage,xsetbg}.1x
  '';

  meta = {
    description = "Graphics file viewer under X11";

    longDescription = ''
      Can view png, jpeg, gif, tiff, niff, sunraster, fbm, cmuraster, pbm,
      faces, rle, xwd, vff, mcidas, vicar, pcx, gem, macpaint, xpm and xbm
      files. Can view images, put them on the root window, or dump them. Does a
      variety of processing, including: clipping, dithering, depth reduction,
      zoom, brightening/darkening and merging.
    '';

    license = lib.licenses.gpl2Plus;

    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux; # arbitrary choice
  };
}
