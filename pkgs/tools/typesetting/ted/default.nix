{ lib, stdenv, fetchurl, pkg-config, zlib, pcre, xorg, libjpeg, libtiff, libpng, gtk2, libpaper, makeWrapper, ghostscript }:

stdenv.mkDerivation rec {
  pname = "ted";
  version = "2.23";

  src = fetchurl {
    url = "http://ftp.nluug.nl/pub/editors/${pname}/${pname}-${version}.src.tar.gz";
    sha256 = "0v1ipynyjklb3chd1vq26a21sjjg66sir57gi2kkrbwnpk195a9z";
  };

  preConfigure = ''
    mkdir pkgconfig-append
    pushd pkgconfig-append

    # ted looks for libtiff, not libtiff-4 in its pkg-config invokations
    cp ${libtiff.dev}/lib/pkgconfig/libtiff-4.pc libtiff.pc

    # ted needs a libpaper pkg-config file
    cat > libpaper.pc << EOF
    prefix=${libpaper}
    libdir=${libpaper}/lib
    includedir=${libpaper}/include
    exec_prefix=\''${prefix}

    Name: libpaper
    Version: ${libpaper.version}
    Description: ${libpaper.meta.description}
    Libs: -L\''${libdir} -lpaper
    Cflags: -I\''${includedir}
    EOF

    export PKG_CONFIG_PATH="$PWD:$PKG_CONFIG_PATH"

    popd
  '';

  makeFlags = [ "CONFIGURE_OPTIONS=--with-GTK" "CONFIGURE_OPTIONS+=--prefix=$(out)" "compile.shared" ];

  installPhase = ''
    runHook preInstall

    make tedPackage/makefile
    pushd tedPackage
    substituteInPlace makefile --replace /usr ""
    make PKGDESTDIR=$out datadir
    popd

    pushd $out/share/Ted/examples
    for f in rtf2*.sh
    do
        makeWrapper "$PWD/$f" "$out/bin/$f" --prefix PATH : $out/bin:${lib.makeBinPath [ ghostscript ]}
    done
    popd

    cp -v Ted/Ted $out/bin

    runHook postInstall
  '';

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ zlib pcre xorg.libX11 xorg.libICE xorg.libSM xorg.libXpm libjpeg libtiff libpng gtk2 libpaper ];

  meta = with lib; {
    description = "An easy rich text processor";
    longDescription = ''
      Ted is a text processor running under X Windows on Unix/Linux systems.
      Ted was developed as a standard easy light weight word processor, having
      the role of Wordpad on MS-Windows. Since then, Ted has evolved to a real
      word processor. It still has the same easy appearance and the same speed
      as the original. The possibility to type a letter, a note or a report
      with a simple light weight program on a Unix/Linux machine is clearly
      missing. Ted was made to make it possible to edit rich text documents on
      Unix/Linux in a wysiwyg way. RTF files from Ted are fully compatible with
      MS-Word. Additionally, Ted also is an RTF to PostScript and an RTF to
      Acrobat PDF converter.
    '';
    homepage    = "https://nllgg.nl/Ted/";
    license     = licenses.gpl2Only;
    platforms   = platforms.all;
    broken      = stdenv.isDarwin;
    maintainers = with maintainers; [ obadz ];
  };
}
