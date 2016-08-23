{ stdenv, fetchurl, patchelf, cups, libusb, libxml2 }:

let

    arch = if stdenv.system == "x86_64-linux"
      then "x86_64"
      else "i386";

in stdenv.mkDerivation rec {
  name = "samsung-unified-linux-driver-${version}";
  version = "1.00.37";

  src = fetchurl {
    sha256 = "0r66l9zp0p1qgakh4j08hynwsr4lsgq5yrpxyr0x4ldvl0z2b1bb";
    url = "http://www.bchemnet.com/suldr/driver/UnifiedLinuxDriver-${version}.tar.gz";
  };

  nativeBuildInputs = [ patchelf ];

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    my_patchelf() {
      opts=(); while [[ "$1" != - ]]; do opts+=( "$1" ); shift; done; shift
      for binary in "$@"; do
        echo "Patching ELF file: $binary"
	patchelf "''${opts[@]}" $binary
        ldd $binary | grep "not found" && exit 1
      done; true
    }

    my_patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      --set-rpath ${cups.out}/lib:$(cat $NIX_CC/nix-support/orig-cc)/lib:${stdenv.glibc}/lib \
      - ${arch}/{pstosecps,rastertospl,smfpnetdiscovery}

    mkdir -p $out/etc/sane.d/dll.d/
    install -m644 noarch/etc/smfp.conf $out/etc/sane.d
    echo smfp >> $out/etc/sane.d/dll.d/smfp-scanner

    mkdir -p $out/lib
    my_patchelf \
      --set-rpath $(cat $NIX_CC/nix-support/orig-cc)/lib:${stdenv.glibc}/lib \
      - ${arch}/libscmssc.so*
    install -m755 ${arch}/libscmssc.so* $out/lib

    mkdir -p $out/lib/cups/backend
    install -m755 ${arch}/smfpnetdiscovery $out/lib/cups/backend

    mkdir -p $out/lib/cups/filter
    install -m755 ${arch}/{pstosecps,rastertospl} $out/lib/cups/filter

    mkdir -p $out/lib/sane
    my_patchelf \
      --set-rpath $(cat $NIX_CC/nix-support/orig-cc)/lib:${stdenv.lib.makeLibraryPath [ stdenv.glibc libusb libxml2 ] } \
      - ${arch}/libsane-smfp.so*
    install -m755 ${arch}/libsane-smfp.so* $out/lib/sane
    ln -s libsane-smfp.so.1.0.1 $out/lib/sane/libsane-smfp.so.1
    ln -s libsane-smfp.so.1     $out/lib/sane/libsane-smfp.so

    mkdir -p $out/lib/udev/rules.d
    (
      OEM_FILE=noarch/oem.conf
      INSTALL_LOG_FILE=/dev/null
      . noarch/scripting_utils
      . noarch/package_utils
      . noarch/scanner-script.pkg
      fill_full_template noarch/etc/smfp.rules.in $out/lib/udev/rules.d/60_smfp_samsung.rules
    )

    mkdir -p $out/share/ppd
    gzip -9 noarch/share/ppd/*.ppd
    cp -R noarch/share/ppd $out/share/ppd/suld

    cp -R noarch/share/locale $out/share
    rm -r $out/share/locale/*/*/install.mo
  '';

  meta = with stdenv.lib; {
    description = "Unified Linux Driver for Samsung printers and scanners";
    homepage = http://www.bchemnet.com/suldr;
    downloadPage = http://www.bchemnet.com/suldr/driver/;
    license = licenses.unfree;

    # Tested on linux-x86_64. Might work on linux-i386.
    # Probably won't work on anything else.
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
