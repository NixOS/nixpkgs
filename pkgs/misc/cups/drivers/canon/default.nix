{stdenv, fetchurl, unzip, autoreconfHook, libtool, makeWrapper, cups, ghostscript, pkgsi686Linux, zlib }:

let

  i686_NIX_GCC = pkgsi686Linux.callPackage ({gcc}: gcc) {};
  i686_libxml2 = pkgsi686Linux.callPackage ({libxml2}: libxml2) {};

  commonVer = "4.10";
  version = "3.70";
  dl = "8/0100007658/08";

  versionNoDots = builtins.replaceStrings ["."] [""] version;
  src_canon = fetchurl {
    url = "http://gdlp01.c-wss.com/gds/${dl}/linux-UFRII-drv-v${versionNoDots}-uken-05.tar.gz";
    sha256 = "0424lvyrsvsb94qga4p4ldis7f714c5yw5ydv3f84mdl2a7papg0";
  };

in


stdenv.mkDerivation {
  pname = "canon-cups-ufr2";
  version = version;
  src = src_canon;

  phases = [ "unpackPhase" "installPhase" ];

  postUnpack = ''
    (cd $sourceRoot; tar -xzf Sources/cndrvcups-common-${commonVer}-1.tar.gz)
    (cd $sourceRoot; tar -xzf Sources/cndrvcups-lb-${version}-1.tar.gz)
  '';

  nativeBuildInputs = [ makeWrapper unzip autoreconfHook libtool ];

  buildInputs = [ cups zlib ];

  installPhase = ''
    ##
    ## cndrvcups-common buildPhase
    ##
    ( cd cndrvcups-common-${commonVer}/buftool
      autoreconf -fi
      ./autogen.sh --prefix=$out --enable-progpath=$out/bin --libdir=$out/lib --disable-shared --enable-static
      make
    )

    ( cd cndrvcups-common-${commonVer}/backend
      ./autogen.sh --prefix=$out --libdir=$out/lib
      make
    )

    ( cd cndrvcups-common-${commonVer}/c3plmod_ipc
      make
    )

    ##
    ## cndrvcups-common installPhase
    ##

    ( cd cndrvcups-common-${commonVer}/buftool
      make install
    )

    ( cd cndrvcups-common-${commonVer}/backend
      make install
    )

    ( cd cndrvcups-common-${commonVer}/c3plmod_ipc
      make install DESTDIR=$out/lib
    )

    ( cd cndrvcups-common-${commonVer}/libs
      chmod 755 *
      mkdir -p $out/lib32
      mkdir -p $out/bin
      cp libcaiowrap.so.1.0.0 $out/lib32
      cp libcaiousb.so.1.0.0 $out/lib32
      cp libc3pl.so.0.0.1 $out/lib32
      cp libcaepcm.so.1.0 $out/lib32
      cp libColorGear.so.0.0.0 $out/lib32
      cp libColorGearC.so.1.0.0 $out/lib32
      cp libcanon_slim.so.1.0.0 $out/lib32
      cp c3pldrv $out/bin
    )

    (cd cndrvcups-common-${commonVer}/Rule
      mkdir -p $out/share/usb
      chmod 644 *.usb-quirks $out/share/usb
    )

    (cd cndrvcups-common-${commonVer}/data
      chmod 644 *.ICC
      mkdir -p $out/share/caepcm
      cp *.ICC $out/share/caepcm
      cp *.icc $out/share/caepcm
      cp *.PRF $out/share/caepcm
    )

    (cd $out/lib32
      ln -sf libc3pl.so.0.0.1 libc3pl.so.0
      ln -sf libc3pl.so.0.0.1 libc3pl.so
      ln -sf libcaepcm.so.1.0 libcaepcm.so.1
      ln -sf libcaepcm.so.1.0 libcaepcm.so
      ln -sf libcaiowrap.so.1.0.0 libcaiowrap.so.1
      ln -sf libcaiowrap.so.1.0.0 libcaiowrap.so
      ln -sf libcaiousb.so.1.0.0 libcaiousb.so.1
      ln -sf libcaiousb.so.1.0.0 libcaiousb.so
      ln -sf libcanon_slim.so.1.0.0 libcanon_slim.so.1
      ln -sf libcanon_slim.so.1.0.0 libcanon_slim.so
      ln -sf libColorGear.so.0.0.0 libColorGear.so.0
      ln -sf libColorGear.so.0.0.0 libColorGear.so
      ln -sf libColorGearC.so.1.0.0 libColorGearC.so.1
      ln -sf libColorGearC.so.1.0.0 libColorGearC.so
    )

    (cd $out/lib
      ln -sf libcanonc3pl.so.1.0.0 libcanonc3pl.so
      ln -sf libcanonc3pl.so.1.0.0 libcanonc3pl.so.1
    )

    patchelf --set-rpath "$(cat ${i686_NIX_GCC}/nix-support/orig-cc)/lib" $out/lib32/libColorGear.so.0.0.0
    patchelf --set-rpath "$(cat ${i686_NIX_GCC}/nix-support/orig-cc)/lib" $out/lib32/libColorGearC.so.1.0.0

    patchelf --interpreter "$(cat ${i686_NIX_GCC}/nix-support/dynamic-linker)" --set-rpath "$out/lib32" $out/bin/c3pldrv

    # c3pldrv is programmed with fixed paths that point to "/usr/{bin,lib.share}/..."
    # preload32 wrappes all necessary function calls to redirect the fixed paths
    # into $out.
    mkdir -p $out/libexec
    preload32=$out/libexec/libpreload32.so
    ${i686_NIX_GCC}/bin/gcc -shared ${./preload.c} -o $preload32 -ldl -DOUT=\"$out\" -fPIC
    wrapProgram "$out/bin/c3pldrv" \
      --set PRELOAD_DEBUG 1 \
      --set LD_PRELOAD $preload32 \
      --prefix LD_LIBRARY_PATH : "$out/lib32"



    ##
    ## cndrvcups-lb buildPhase
    ##

    ( cd cndrvcups-lb-${version}/buftool
      ./autogen.sh --prefix=$out --libdir=$out/lib --enable-progpath=$out/bin --enable-static
      make
    )

    ( cd cndrvcups-lb-${version}/pstoufr2cpca
      ./autogen.sh --prefix=$out --libdir=$out/lib
      make
    )

    ##
    ## cndrvcups-lb installPhase
    ##

    ( cd cndrvcups-lb-${version}/pstoufr2cpca
      make install
    )

    ( cd cndrvcups-lb-${version}/libs
      chmod 755 *
      mkdir -p $out/lib32
      mkdir -p $out/bin
      cp libcanonufr2.la $out/lib32
      cp libcanonufr2.so.1.0.0 $out/lib32
      cp libufr2filter.so.1.0.0 $out/lib32
      cp libEnoJBIG.so.1.0.0 $out/lib32
      cp libEnoJPEG.so.1.0.0 $out/lib32
      cp libcaiocnpkbidi.so.1.0.0 $out/lib32
      cp libcnlbcm.so.1.0 $out/lib32

      cp cnpkmoduleufr2 $out/bin #maybe needs setuid 4755
      cp cnpkbidi $out/bin
    )

    ( cd $out/lib32
      ln -sf libcanonufr2.so.1.0.0 libcanonufr2.so
      ln -sf libcanonufr2.so.1.0.0 libcanonufr2.so.1
      ln -sf libufr2filter.so.1.0.0 libufr2filter.so
      ln -sf libufr2filter.so.1.0.0 libufr2filter.so.1
      ln -sf libEnoJBIG.so.1.0.0 libEnoJBIG.so
      ln -sf libEnoJBIG.so.1.0.0 libEnoJBIG.so.1
      ln -sf libEnoJPEG.so.1.0.0 libEnoJPEG.so
      ln -sf libEnoJPEG.so.1.0.0 libEnoJPEG.so.1
      ln -sf libcaiocnpkbidi.so.1.0.0 libcaiocnpkbidi.so
      ln -sf libcaiocnpkbidi.so.1.0.0 libcaiocnpkbidi.so.1
      ln -sf libcnlbcm.so.1.0 libcnlbcm.so.1
      ln -sf libcnlbcm.so.1.0 libcnlbcm.so
    )

    ( cd cndrvcups-lb-${version}
      chmod 644 data/CnLB*
      chmod 644 libs/cnpkbidi_info*
      chmod 644 libs/ThLB*
      mkdir -p $out/share/caepcm
      mkdir -p $out/share/cnpkbidi
      mkdir -p $out/share/ufr2filter
      cp data/CnLB* $out/share/caepcm
      cp libs/cnpkbidi_info* $out/share/cnpkbidi
      cp libs/ThLB* $out/share/ufr2filter
    )

    mkdir -p $out/share/cups/model
    install -c -m 644 cndrvcups-lb-${version}/ppd/CN*.ppd $out/share/cups/model/

    patchelf --set-rpath "$out/lib32:${i686_libxml2.out}/lib" $out/lib32/libcanonufr2.so.1.0.0

    patchelf --interpreter "$(cat ${i686_NIX_GCC}/nix-support/dynamic-linker)" --set-rpath "$out/lib32" $out/bin/cnpkmoduleufr2
    patchelf --interpreter "$(cat ${i686_NIX_GCC}/nix-support/dynamic-linker)" --set-rpath "$out/lib32:${i686_libxml2.out}/lib" $out/bin/cnpkbidi

    makeWrapper "${ghostscript}/bin/gs" "$out/bin/gs" \
      --prefix LD_LIBRARY_PATH ":" "$out/lib" \
      --prefix PATH ":" "$out/bin"
    '';

  meta = with stdenv.lib; {
    description = "CUPS Linux drivers for Canon printers";
    homepage = "http://www.canon.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [
      kylesferrazza
    ];
  };
}
