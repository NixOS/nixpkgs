{stdenv, fetchurl, fetchpatch, makeWrapper, symlinkJoin,
pkgconfig, libtool,
gtk2,
libxml2,
libxslt,
libusb,
sane-backends,
rpm, cpio,
eject,
patchelf, gcc
}:

let common_meta = {
    homepage = "http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX";
    license = with stdenv.lib.licenses; epson;
    platforms = with stdenv.lib.platforms; linux;
   };
in
############################
#
#  PLUGINS
#
############################

# adding a plugin for another printer shouldn't be too difficult, but you need the firmware to test...

let plugins = {
  f720 = stdenv.mkDerivation rec {
    name = "iscan-gt-f720-bundle";
    version = "1.0.1";
    pluginVersion = "0.1.1-2";

    buildInputs = [ patchelf ];
    src = fetchurl {
      url = "https://download2.ebz.epson.net/iscan/plugin/gt-f720/rpm/x64/iscan-gt-f720-bundle-${version}.x64.rpm.tar.gz";
      sha256 = "0dvikq5ad6wid3lxw1amar8lsbr50g39g6zlmcjxdcsg0wb1qspp";
    };
    installPhase = ''
      cd plugins
      ${rpm}/bin/rpm2cpio esci-interpreter-gt-f720-${pluginVersion}.x86_64.rpm | ${cpio}/bin/cpio -idmv
      mkdir $out
      cp -r usr/share $out
      cp -r usr/lib64 $out/lib
      '';
    preFixup = ''
      lib=$out/lib/esci/libesci-interpreter-gt-f720.so
      rpath=${gcc.cc.lib}/lib/
      patchelf --set-rpath $rpath $lib
      '';
    passthru = {
      registrationCommand = ''
        $registry --add interpreter usb 0x04b8 0x0131 "$plugin/lib/esci/libesci-interpreter-gt-f720 $plugin/share/esci/esfw8b.bin"
        '';
      hw = "GT-F720, GT-S620, Perfection V30, Perfection V300 Photo";
      };

    meta = common_meta // { description = "iscan esci f720 plugin for "+passthru.hw; };
  };
};
in



let fwdir = symlinkJoin {
  name = "esci-firmware-dir";
  paths = stdenv.lib.mapAttrsToList (name: value: value + /share/esci) plugins;
};
in
let iscan-data = stdenv.mkDerivation rec {
  name = "iscan-data-${version}";
  version = "1.39.0-1";

  src = fetchurl {
    url = "http://support.epson.net/linux/src/scanner/iscan/iscan-data_${version}.tar.gz";
    sha256 = "0pvm67gqyvzhnv5qyfbaz802l4sbgvaf0zb8wz60k1wcasb99vv1";
  };

  buildInputs = [
    libxslt
  ];

  meta = common_meta;
};
in
stdenv.mkDerivation rec {
  name = "iscan-${version}";
  version = "2.30.3-1";

  src = fetchurl {
    url = "http://support.epson.net/linux/src/scanner/iscan/iscan_${version}.tar.gz";
    sha256 = "0ryy946h7ddmxh866hfszqfyff1qy4svpsk7w3739v75f4awr9li";
  };

  buildInputs = [
    pkgconfig
    gtk2
    libxml2
    libtool
    libusb
    sane-backends
    makeWrapper
  ];

  patches = [
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-gfx/iscan/files/iscan-2.28.1.3+libpng-1.5.patch";
      sha256 = "04y70qjd220dpyh771fiq50lha16pms98mfigwjczdfmx6kpj1jd";
    })
    ./firmware_location.patch
    ];
  patchFlags = "-p0";

  configureFlags = [ "--disable-static" "--enable-dependency-reduction" "--disable-frontend"];

  postConfigure = ''
    echo '#define NIX_ESCI_PREFIX "'${fwdir}'"' >> config.h
    '';

  postInstall = ''
    mkdir -p $out/etc/sane.d
    cp backend/epkowa.conf $out/etc/sane.d
    echo "epkowa" > $out/etc/sane.d/dll.conf
    ln -s ${iscan-data}/share/iscan-data $out/share/iscan-data
    '';
  postFixup = ''
    # iscan-registry is a shell script requiring getopt
    wrapProgram $out/bin/iscan-registry --prefix PATH : ${eject}/bin
    registry=$out/bin/iscan-registry;
    '' +
    stdenv.lib.concatStrings (stdenv.lib.mapAttrsToList (name: value: ''
    plugin=${value};
    ${value.passthru.registrationCommand}
    '') plugins);
  meta = common_meta // {
    description = "sane-epkowa backend for some epson scanners.";
    longDescription = ''
      Includes gui-less iscan (aka. Image Scan! for Linux).
      Supported hardware: at least :
    '' +
    stdenv.lib.concatStringsSep ", " (stdenv.lib.mapAttrsToList (name: value: value.passthru.hw) plugins);
  };
}
