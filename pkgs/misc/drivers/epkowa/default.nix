{stdenv, fetchurl, fetchpatch, makeWrapper, symlinkJoin,
pkgconfig, libtool,
gtk2,
libxml2,
libxslt,
libusb,
sane-backends,
rpm, cpio,
getopt,
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
  v330 = stdenv.mkDerivation rec {
    name = "iscan-v330-bundle";
    version = "1.0.1";
    pluginVersion = "0.2.0";

    src = fetchurl {
      url = "https://download2.ebz.epson.net/iscan/plugin/perfection-v330/rpm/x64/iscan-perfection-v330-bundle-${version}.x64.rpm.tar.gz";
      sha256 = "f6fa455f04cdfbc3d38526573260746e9546830de93ba182d0365f557d2f7df9";
    };

    buildInputs = [ patchelf rpm ];

    installPhase = ''
      ${rpm}/bin/rpm2cpio "plugins/esci-interpreter-perfection-v330-${pluginVersion}-1.x86_64.rpm" | ${cpio}/bin/cpio -idmv
      mkdir $out{,/share,/lib}
      cp -r ./usr/share/{iscan-data,esci}/ $out/share/
      cp -r ./usr/lib64/esci $out/lib
      '';

    preFixup = ''
      lib=$out/lib/esci/libesci-interpreter-perfection-v330.so
      rpath=${gcc.cc.lib}/lib/
      patchelf --set-rpath $rpath $lib
      '';

    passthru = {
      registrationCommand = ''
        $registry --add interpreter usb 0x04b8 0x0142 "$plugin/lib/esci/libesci-interpreter-perfection-v330 $plugin/share/esci/esfwad.bin"
        '';
      hw = "Perfection V330 Photo";
      };
    meta = common_meta // { description = "Plugin to support "+passthru.hw+" scanner in sane."; };
  };
  x770 =   stdenv.mkDerivation rec {
    pname = "iscan-gt-x770-bundle";
    version = "1.0.1";
    pluginVersion = "2.1.2-1";

    nativeBuildInputs = [ patchelf rpm ];
    src = fetchurl {
      url = "https://download2.ebz.epson.net/iscan/plugin/gt-x770/rpm/x64/iscan-gt-x770-bundle-${version}.x64.rpm.tar.gz";
      sha256 = "0m9c60rszzdvq1pqfzygzzrjycm1giy465lj29108j7hsnfcv56r";
    };
    installPhase = ''
      cd plugins
      ${rpm}/bin/rpm2cpio iscan-plugin-gt-x770-${pluginVersion}.x86_64.rpm | ${cpio}/bin/cpio -idmv
      mkdir $out
      cp -r usr/share $out
      cp -r usr/lib64 $out/lib
      mv $out/share/iscan $out/share/esci
      mv $out/lib/iscan $out/lib/esci
      '';
    preFixup = ''
      lib=$out/lib/esci/libesint7C.so
      rpath=${gcc.cc.lib}/lib/
      patchelf --set-rpath $rpath $lib
      '';
    passthru = {
      registrationCommand = ''
        $registry --add interpreter usb 0x04b8 0x0130 "$plugin/lib/esci/libesint7C $plugin/share/esci/esfw7C.bin"
        '';
      hw = "Perfection V500 Photo";
      };
    meta = common_meta // { description = "iscan esci x770 plugin for "+passthru.hw; };
    };
  f720 = stdenv.mkDerivation rec {
    pname = "iscan-gt-f720-bundle";
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
  s80 = stdenv.mkDerivation rec {
    pname = "iscan-gt-s80-bundle";
    version = "1.0.1";
    esciPluginVersion = "0.2.1-1";
    esdipPluginVersion = "1.0.0-5";

    buildInputs = [ patchelf ];
    src = fetchurl {
      url = "https://download2.ebz.epson.net/iscan/plugin/gt-s80/rpm/x64/iscan-gt-s80-bundle-${version}.x64.rpm.tar.gz";
      sha256 = "14j11znx5ga2ykpyg6kjg7lbrddyr9pwxrsa82dmdishd1j7zji9";
    };
    installPhase = ''
      cd plugins
      ${rpm}/bin/rpm2cpio esci-interpreter-gt-s80-${esciPluginVersion}.x86_64.rpm | ${cpio}/bin/cpio -idmv
      ${rpm}/bin/rpm2cpio iscan-plugin-esdip-${esdipPluginVersion}.ltdl7.x86_64.rpm | ${cpio}/bin/cpio -idmv
      mkdir $out
      cp -r usr/share $out
      cp -r usr/lib64 $out/lib
      mkdir $out/share/esci
      '';
    preFixup = ''
      rpath=${gcc.cc.lib}/lib/
      patchelf --set-rpath $rpath $out/lib/esci/libesci-interpreter-gt-s80.so
      patchelf --set-rpath $rpath $out/lib/esci/libesci-interpreter-gt-s50.so
      patchelf --set-rpath $rpath $out/lib/iscan/esdip
      patchelf --set-rpath $rpath $out/lib/iscan/libesdtr.so.0
      patchelf --set-rpath $rpath $out/lib/iscan/libesdtr2.so.0
      '';
    passthru = {
      registrationCommand = ''
        $registry --add interpreter usb 0x04b8 0x0136 "$plugin/lib/esci/libesci-interpreter-gt-s80.so"
        $registry --add interpreter usb 0x04b8 0x0137 "$plugin/lib/esci/libesci-interpreter-gt-s50.so"
        $registry --add interpreter usb 0x04b8 0x0143 "$plugin/lib/esci/libesci-interpreter-gt-s50.so"
        $registry --add interpreter usb 0x04b8 0x0144 "$plugin/lib/esci/libesci-interpreter-gt-s80.so"
        '';
      hw = "ES-D200, ED-D350, ES-D400, GT-S50, GT-S55, GT-S80, GT-S85";
      };

    meta = common_meta // { description = "iscan esci s80 plugin for "+passthru.hw; };
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

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk2
    libxml2
    libtool
    libusb
    sane-backends
    makeWrapper
  ];

  patches = [
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-gfx/iscan/files/iscan-2.28.1.3+libpng-1.5.patch?h=b6e4c805d53b49da79a0f64ef16bb82d6d800fcf";
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
    wrapProgram $out/bin/iscan-registry --prefix PATH : ${getopt}/bin
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
    maintainers = with stdenv.lib.maintainers; [ symphorien ];
  };
}
