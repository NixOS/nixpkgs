{ lib
, stdenv
, fetchurl
, unzip
, autoconf
, automake
, libtool_1_5
, makeWrapper
, cups
, jbigkit
, glib
, gtk3
, gdk-pixbuf
, pango
, cairo
, coreutils
, atk
, pkg-config
, gnome2
, libxml2
, runtimeShell
, proot
, ghostscript
, pkgs
, pkgsi686Linux
, zlib
}:

let

  i686_NIX_GCC = pkgsi686Linux.callPackage ({ gcc }: gcc) { };
  ld32 =
    if stdenv.hostPlatform.system == "x86_64-linux" then "${stdenv.cc}/nix-support/dynamic-linker-m32"
    else if stdenv.hostPlatform.system == "i686-linux" then "${stdenv.cc}/nix-support/dynamic-linker"
    else throw "Unsupported platform for Canon UFR2 Drivers: ${stdenv.hostPlatform.system}";
  ld64 = "${stdenv.cc}/nix-support/dynamic-linker";
  libs = pkgs: lib.makeLibraryPath buildInputs;

  version = "5.40";
  dl = "6/0100009236/10";

  versionNoDots = builtins.replaceStrings [ "." ] [ "" ] version;
  src_canon = fetchurl {
    url = "http://gdlp01.c-wss.com/gds/${dl}/linux-UFRII-drv-v${versionNoDots}-usen-20.tar.gz";
    sha256 = "sha256:069z6ijmql62mcdyxnzc9mf0dxa6z1107cd0ab4i1adk8kr3d75k";
  };

  buildInputs = [ cups zlib jbigkit glib gtk3 pkg-config gnome2.libglade libxml2 gdk-pixbuf pango cairo atk ];

in


stdenv.mkDerivation rec {
  pname = "canon-cups-ufr2";
  inherit version;
  src = src_canon;

  postUnpack = ''
    (cd $sourceRoot; tar -xzf Sources/cnrdrvcups-lb-${version}-1.tar.gz)
    (cd $sourceRoot; sed -ie "s@_prefix=/usr@_prefix=$out@" cnrdrvcups-common-${version}/allgen.sh)
    (cd $sourceRoot; sed -ie "s@_libdir=/usr/lib@_libdir=$out/lib@" cnrdrvcups-common-${version}/allgen.sh)
    (cd $sourceRoot; sed -ie "s@_bindir=/usr/bin@_libdir=$out/bin@" cnrdrvcups-common-${version}/allgen.sh)
    (cd $sourceRoot; sed -ie "s@etc/cngplp@$out/etc/cngplp@" cnrdrvcups-common-${version}/cngplp/Makefile.am)
    (cd $sourceRoot; sed -ie "s@usr/share/cngplp@$out/usr/share/cngplp@" cnrdrvcups-common-${version}/cngplp/src/Makefile.am)
    (cd $sourceRoot; patchShebangs cnrdrvcups-common-${version})

    (cd $sourceRoot; sed -ie "s@_prefix=/usr@_prefix=$out@" cnrdrvcups-lb-${version}/allgen.sh)
    (cd $sourceRoot; sed -ie "s@_libdir=/usr/lib@_libdir=$out/lib@" cnrdrvcups-lb-${version}/allgen.sh)
    (cd $sourceRoot; sed -ie "s@_bindir=/usr/bin@_libdir=$out/bin@" cnrdrvcups-lb-${version}/allgen.sh)
    (cd $sourceRoot; sed -ie '/^cd \.\.\/cngplp/,/^cd files/{/^cd files/!{d}}' cnrdrvcups-lb-${version}/allgen.sh)
    (cd $sourceRoot; sed -ie "s@cd \.\./pdftocpca@cd pdftocpca@" cnrdrvcups-lb-${version}/allgen.sh)
    (cd $sourceRoot; sed -i "/CNGPLPDIR/d" cnrdrvcups-lb-${version}/Makefile)
    (cd $sourceRoot; patchShebangs cnrdrvcups-lb-${version})
  '';

  nativeBuildInputs = [ makeWrapper unzip autoconf automake libtool_1_5 ];

  inherit buildInputs;

  installPhase = ''
    runHook preInstall

    (
      cd cnrdrvcups-common-${version}
      ./allgen.sh
      make install
    )
    (
      cd cnrdrvcups-common-${version}/Rule
      mkdir -p $out/share/usb
      install -m 644 *.usb-quirks $out/share/usb
    )
    (
      cd cnrdrvcups-lb-${version}
      ./allgen.sh
      make install

      mkdir -p $out/share/cups/model
      install -m 644 ppd/*.ppd $out/share/cups/model/
    )
    (
      cd lib
      mkdir -p $out/lib32
      install -m 755 libs32/intel/libColorGearCufr2.so.2.0.0 $out/lib32
      install -m 755 libs32/intel/libcaepcmufr2.so.1.0 $out/lib32
      install -m 755 libs32/intel/libcaiocnpkbidir.so.1.0.0 $out/lib32
      install -m 755 libs32/intel/libcaiousb.so.1.0.0 $out/lib32
      install -m 755 libs32/intel/libcaiowrapufr2.so.1.0.0 $out/lib32
      install -m 755 libs32/intel/libcanon_slimufr2.so.1.0.0 $out/lib32
      install -m 755 libs32/intel/libcanonufr2r.so.1.0.0 $out/lib32
      install -m 755 libs32/intel/libcnaccm.so.1.0 $out/lib32
      install -m 755 libs32/intel/libcnlbcmr.so.1.0 $out/lib32
      install -m 755 libs32/intel/libcnncapcmr.so.1.0 $out/lib32
      install -m 755 libs32/intel/libufr2filterr.so.1.0.0 $out/lib32

      mkdir -p $out/lib
      install -m 755 libs64/intel/libColorGearCufr2.so.2.0.0 $out/lib
      install -m 755 libs64/intel/libcaepcmufr2.so.1.0 $out/lib
      install -m 755 libs64/intel/libcaiocnpkbidir.so.1.0.0 $out/lib
      install -m 755 libs64/intel/libcaiousb.so.1.0.0 $out/lib
      install -m 755 libs64/intel/libcaiowrapufr2.so.1.0.0 $out/lib
      install -m 755 libs64/intel/libcanon_slimufr2.so.1.0.0 $out/lib
      install -m 755 libs64/intel/libcanonufr2r.so.1.0.0 $out/lib
      install -m 755 libs64/intel/libcnaccm.so.1.0 $out/lib
      install -m 755 libs64/intel/libcnlbcmr.so.1.0 $out/lib
      install -m 755 libs64/intel/libcnncapcmr.so.1.0 $out/lib
      install -m 755 libs64/intel/libufr2filterr.so.1.0.0 $out/lib

      install -m 755 libs64/intel/cnpdfdrv $out/bin
      install -m 755 libs64/intel/cnpkbidir $out/bin
      install -m 755 libs64/intel/cnpkmoduleufr2r $out/bin
      install -m 755 libs64/intel/cnrsdrvufr2 $out/bin
      install -m 755 libs64/intel/cnsetuputil2 $out/bin/cnsetuputil2

      mkdir -p $out/share/cnpkbidir
      install -m 644 libs64/intel/cnpkbidir_info* $out/share/cnpkbidir

      mkdir -p $out/share/ufr2filter
      install -m 644 libs64/intel/ThLB* $out/share/ufr2filter
    )

    (
      cd $out/lib32
      ln -sf libcaepcmufr2.so.1.0 libcaepcmufr2.so
      ln -sf libcaepcmufr2.so.1.0 libcaepcmufr2.so.1
      ln -sf libcaiowrapufr2.so.1.0.0 libcaiowrapufr2.so
      ln -sf libcaiowrapufr2.so.1.0.0 libcaiowrapufr2.so.1
      ln -sf libcanon_slimufr2.so.1.0.0 libcanon_slimufr2.so
      ln -sf libcanon_slimufr2.so.1.0.0 libcanon_slimufr2.so.1
      ln -sf libufr2filterr.so.1.0.0 libufr2filterr.so
      ln -sf libufr2filterr.so.1.0.0 libufr2filterr.so.1

      patchelf --set-rpath "$(cat ${i686_NIX_GCC}/nix-support/orig-cc)/lib:${libs pkgsi686Linux}:${pkgsi686Linux.stdenv.cc.libc}/lib:${pkgsi686Linux.libxml2.out}/lib:$out/lib32" libcanonufr2r.so.1.0.0
      patchelf --set-rpath "$(cat ${i686_NIX_GCC}/nix-support/orig-cc)/lib:${libs pkgsi686Linux}:${pkgsi686Linux.stdenv.cc.libc}/lib" libcaepcmufr2.so.1.0
      patchelf --set-rpath "$(cat ${i686_NIX_GCC}/nix-support/orig-cc)/lib:${libs pkgsi686Linux}:${pkgsi686Linux.stdenv.cc.libc}/lib" libColorGearCufr2.so.2.0.0
    )

    (
      cd $out/lib
      ln -sf libcaepcmufr2.so.1.0 libcaepcmufr2.so
      ln -sf libcaepcmufr2.so.1.0 libcaepcmufr2.so.1
      ln -sf libcaiowrapufr2.so.1.0.0 libcaiowrapufr2.so
      ln -sf libcaiowrapufr2.so.1.0.0 libcaiowrapufr2.so.1
      ln -sf libcanon_slimufr2.so.1.0.0 libcanon_slimufr2.so
      ln -sf libcanon_slimufr2.so.1.0.0 libcanon_slimufr2.so.1
      ln -sf libufr2filterr.so.1.0.0 libufr2filterr.so
      ln -sf libufr2filterr.so.1.0.0 libufr2filterr.so.1

      patchelf --set-rpath "$(cat $NIX_CC/nix-support/orig-cc)/lib:${libs pkgs}:${stdenv.cc.cc.lib}/lib64:${stdenv.cc.libc}/lib64:$out/lib" libcanonufr2r.so.1.0.0
      patchelf --set-rpath "$(cat $NIX_CC/nix-support/orig-cc)/lib:${libs pkgs}:${stdenv.cc.cc.lib}/lib64:${stdenv.cc.libc}/lib64" libcaepcmufr2.so.1.0
      patchelf --set-rpath "$(cat $NIX_CC/nix-support/orig-cc)/lib:${libs pkgs}:${stdenv.cc.cc.lib}/lib64:${stdenv.cc.libc}/lib64" libColorGearCufr2.so.2.0.0
    )

    (
      cd $out/bin
      patchelf --set-interpreter "$(cat ${ld64})" --set-rpath "${lib.makeLibraryPath buildInputs}:${stdenv.cc.cc.lib}/lib64:${stdenv.cc.libc}/lib64" cnsetuputil2
      patchelf --set-interpreter "$(cat ${ld64})" --set-rpath "${lib.makeLibraryPath buildInputs}:${stdenv.cc.cc.lib}/lib64:${stdenv.cc.libc}/lib64" cnpdfdrv
      patchelf --set-interpreter "$(cat ${ld64})" --set-rpath "${lib.makeLibraryPath buildInputs}:${stdenv.cc.cc.lib}/lib64:${stdenv.cc.libc}/lib64:$out/lib" cnpkbidir
      patchelf --set-interpreter "$(cat ${ld64})" --set-rpath "${lib.makeLibraryPath buildInputs}:${stdenv.cc.cc.lib}/lib64:${stdenv.cc.libc}/lib64:$out/lib" cnrsdrvufr2

      mv cnsetuputil2 cnsetuputil2.wrapped
      echo "#!${runtimeShell} -e" > cnsetuputil2
      echo "exec ${proot}/bin/proot -b $out/usr/share/cnsetuputil2:/usr/share/cnsetuputil2 -b ${coreutils}/bin/ls:/bin/ls -b ${cups}/share:/usr/share/cups $out/bin/cnsetuputil2.wrapped" > cnsetuputil2
      chmod +x cnsetuputil2
    )

    (
      cd lib/data/ufr2
      mkdir -p $out/share/caepcm
      install -m 644 *.ICC $out/share/caepcm
      install -m 644 *.icc $out/share/caepcm
      install -m 644 *.PRF $out/share/caepcm
      install -m 644 CnLB* $out/share/caepcm
    )

    (
      cd cnrdrvcups-utility-${version}/data
      mkdir -p $out/usr/share/cnsetuputil2
      install -m 644 cnsetuputil* $out/usr/share/cnsetuputil2
    )

    makeWrapper "${ghostscript}/bin/gs" "$out/bin/gs" \
      --prefix LD_LIBRARY_PATH ":" "$out/lib" \
      --prefix PATH ":" "$out/bin"

    runHook postInstall
  '';

  meta = with lib; {
    description = "CUPS Linux drivers for Canon printers";
    homepage = "http://www.canon.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [
      # please consider maintaining if you are updating this package
    ];
  };
}
