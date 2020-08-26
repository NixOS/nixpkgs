{stdenv, fetchurl, fetchpatch, makeWrapper, symlinkJoin,
pkgconfig, libtool,
gtk2,
libxml2,
libxslt,
libusb-compat-0_1,
sane-backends,
rpm, cpio,
getopt,
patchelf, autoPatchelfHook, gcc
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
    version = "2.30.4";

    src = fetchurl {
      # To find new versions, visit
      # http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX and search for
      # some printer like for instance "WF-7210" to get to the most recent
      # version.  
      # NOTE: Don't forget to update the webarchive link too!
      urls = [
        "https://download2.ebz.epson.net/iscan/plugin/perfection-v330/rpm/x64/iscan-perfection-v330-bundle-${version}.x64.rpm.tar.gz"
        "https://web.archive.org/web/https://download2.ebz.epson.net/iscan/plugin/perfection-v330/rpm/x64/iscan-perfection-v330-bundle-${version}.x64.rpm.tar.gz"
      ];
      sha256 = "056c04pfsf98nnknphg28l489isqb6y4l2c8g7wqhclwgj7m338i";
    };

    nativeBuildInputs = [ autoPatchelfHook rpm ];

    installPhase = ''
      ${rpm}/bin/rpm2cpio plugins/esci-interpreter-perfection-v330-*.x86_64.rpm | ${cpio}/bin/cpio -idmv
      mkdir $out{,/share,/lib}
      cp -r ./usr/share/{iscan-data,esci}/ $out/share/
      cp -r ./usr/lib64/esci $out/lib
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
    version = "2.30.4";

    nativeBuildInputs = [ autoPatchelfHook rpm ];
    src = fetchurl {
      urls = [
        "https://download2.ebz.epson.net/iscan/plugin/gt-x770/rpm/x64/iscan-gt-x770-bundle-${version}.x64.rpm.tar.gz"
        "https://web.archive.org/web/https://download2.ebz.epson.net/iscan/plugin/gt-x770/rpm/x64/iscan-gt-x770-bundle-${version}.x64.rpm.tar.gz"
      ];
      sha256 = "1chxdm6smv2d14pn2jl9xyd0vr42diy7vpskd3b9a61gf5h3gj03";
    };
    installPhase = ''
      cd plugins
      ${rpm}/bin/rpm2cpio iscan-plugin-gt-x770-*.x86_64.rpm | ${cpio}/bin/cpio -idmv
      mkdir $out
      cp -r usr/share $out
      cp -r usr/lib64 $out/lib
      mv $out/share/iscan $out/share/esci
      mv $out/lib/iscan $out/lib/esci
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
    version = "2.30.4";

    nativeBuildInputs= [ autoPatchelfHook ];
    buildInputs = [ gcc.cc.lib ];
    src = fetchurl {
      urls = [
        "https://download2.ebz.epson.net/iscan/plugin/gt-f720/rpm/x64/iscan-gt-f720-bundle-${version}.x64.rpm.tar.gz"
        "https://web.archive.org/web/https://download2.ebz.epson.net/iscan/plugin/gt-f720/rpm/x64/iscan-gt-f720-bundle-${version}.x64.rpm.tar.gz"
      ];
      sha256 = "1xnbmb2rn610kqpg1x6k1cc13zlmx2f3l2xnj6809rnhg96qqn20";
    };
    installPhase = ''
      cd plugins
      ${rpm}/bin/rpm2cpio esci-interpreter-gt-f720-*.x86_64.rpm | ${cpio}/bin/cpio -idmv
      mkdir $out
      cp -r usr/share $out
      cp -r usr/lib64 $out/lib
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
    version = "2.30.4";

    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [ gcc.cc.lib libtool ];
    src = fetchurl {
      urls = [
        "https://download2.ebz.epson.net/iscan/plugin/gt-s80/rpm/x64/iscan-gt-s80-bundle-${version}.x64.rpm.tar.gz"
        "https://web.archive.org/web/https://download2.ebz.epson.net/iscan/plugin/gt-s80/rpm/x64/iscan-gt-s80-bundle-${version}.x64.rpm.tar.gz"
      ];
      sha256 = "00qfdgs03k7bbs67zjrk8hbxvlyinsmk890amp9cmpfjfzdxgg58";
    };
    installPhase = ''
      cd plugins
      ${rpm}/bin/rpm2cpio esci-interpreter-gt-s80-*.x86_64.rpm | ${cpio}/bin/cpio -idmv
      ${rpm}/bin/rpm2cpio iscan-plugin-esdip-*.x86_64.rpm | ${cpio}/bin/cpio -idmv
      mkdir $out
      cp -r usr/share $out
      cp -r usr/lib64 $out/lib
      mkdir $out/share/esci
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
  s650 = stdenv.mkDerivation rec {
    name = "iscan-gt-s650-bundle";
    version = "2.30.4";

    src = fetchurl {
      urls = [
        "https://download2.ebz.epson.net/iscan/plugin/gt-s650/rpm/x64/iscan-gt-s650-bundle-${version}.x64.rpm.tar.gz"
        "https://web.archive.org/web/https://download2.ebz.epson.net/iscan/plugin/gt-s650/rpm/x64/iscan-gt-s650-bundle-${version}.x64.rpm.tar.gz"
      ];
      sha256 = "0fn4lz4g0a8l301v6yv7fwl37wgwhz5y90nf681f655xxc91hqh7";
    };

    nativeBuildInputs = [ autoPatchelfHook rpm ];

    installPhase = ''
      cd plugins
      ${rpm}/bin/rpm2cpio iscan-plugin-gt-s650-*.x86_64.rpm | ${cpio}/bin/cpio -idmv
      mkdir $out
      cp -r usr/share $out
      cp -r usr/lib64 $out/lib
      mv $out/share/iscan $out/share/esci
      mv $out/lib/iscan $out/lib/esci
      '';

    passthru = {
      registrationCommand = ''
        $registry --add interpreter usb 0x04b8 0x013c "$plugin/lib/esci/libiscan-plugin-gt-s650 $plugin/share/esci/esfw010c.bin"
        $registry --add interpreter usb 0x04b8 0x013d "$plugin/lib/esci/libiscan-plugin-gt-s650 $plugin/share/esci/esfw010c.bin"
        '';
      hw = "GT-S650, Perfection V19, Perfection V39";
    };
    meta = common_meta // { description = "iscan GT-S650 for "+passthru.hw; };
  };
  network = stdenv.mkDerivation rec {
    pname = "iscan-nt-bundle";
    # for the version, look for the driver of XP-750 in the search page
    version = "2.30.4";

    buildInputs = [ stdenv.cc.cc.lib ];
    nativeBuildInputs = [ autoPatchelfHook ];

    src = fetchurl {
      urls = [
        "https://download2.ebz.epson.net/iscan/general/rpm/x64/iscan-bundle-${version}.x64.rpm.tar.gz"
        "https://web.archive.org/web/https://download2.ebz.epson.net/iscan/general/rpm/x64/iscan-bundle-${version}.x64.rpm.tar.gz"
      ];
      sha256 = "0jssigsgkxb9i7qa7db291a1gbvwl795i4ahvb7bnqp33czkj85k";
    };
    installPhase = ''
      cd plugins
      ${rpm}/bin/rpm2cpio iscan-network-nt-*.x86_64.rpm | ${cpio}/bin/cpio -idmv

      mkdir $out
      cp -r usr/share $out
      cp -r usr/lib64 $out/lib
      mkdir $out/share/esci
      '';
    passthru = {
      registrationCommand = "";
      hw = "network";
    };

    meta = common_meta // { description = "iscan network plugin"; };
  };
};
in



let fwdir = symlinkJoin {
  name = "esci-firmware-dir";
  paths = stdenv.lib.mapAttrsToList (name: value: value + /share/esci) plugins;
};
in
let iscan-data = stdenv.mkDerivation rec {
  pname = "iscan-data";
  version = "1.39.1-2";

  src = fetchurl {
    urls = [
      "http://support.epson.net/linux/src/scanner/iscan/iscan-data_${version}.tar.gz"
      "https://web.archive.org/web/http://support.epson.net/linux/src/scanner/iscan/iscan-data_${version}.tar.gz"
    ];
    sha256 = "04zrvbnxf1k6zinrd13hwnbzscc3qhmwlvx3k2jhjys2lginw7w4";
  };

  buildInputs = [
    libxslt
  ];

  meta = common_meta;
};
in
stdenv.mkDerivation rec {
  pname = "iscan";
  version = "2.30.4-2";

  src = fetchurl {
    urls = [
      "http://support.epson.net/linux/src/scanner/iscan/iscan_${version}.tar.gz"
      "https://web.archive.org/web/http://support.epson.net/linux/src/scanner/iscan/iscan_${version}.tar.gz"
    ];
    sha256 = "1ma76jj0k3bz0fy06fiyl4di4y77rcryb0mwjmzs5ms2vq9rjysr";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk2
    libxml2
    libtool
    libusb-compat-0_1
    sane-backends
    makeWrapper
  ];

  patches = [
    (fetchpatch {
      urls = [
        "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-gfx/iscan/files/iscan-2.28.1.3+libpng-1.5.patch?h=b6e4c805d53b49da79a0f64ef16bb82d6d800fcf"
        "https://web.archive.org/web/https://gitweb.gentoo.org/repo/gentoo.git/plain/media-gfx/iscan/files/iscan-2.28.1.3+libpng-1.5.patch?h=b6e4c805d53b49da79a0f64ef16bb82d6d800fcf"
      ];
      sha256 = "04y70qjd220dpyh771fiq50lha16pms98mfigwjczdfmx6kpj1jd";
    })
    ./firmware_location.patch
    ./sscanf.patch
    ];
  patchFlags = [ "-p0" ];

  configureFlags = [ "--enable-dependency-reduction" "--disable-frontend"];

  postConfigure = ''
    echo '#define NIX_ESCI_PREFIX "'${fwdir}'"' >> config.h
    '';

  postInstall = ''
    mkdir -p $out/etc/sane.d
    cp backend/epkowa.conf $out/etc/sane.d
    echo "epkowa" > $out/etc/sane.d/dll.conf
    ln -s ${iscan-data}/share/iscan-data $out/share/iscan-data
    mkdir -p $out/lib/iscan
    ln -s ${plugins.network}/lib/iscan/network $out/lib/iscan/network
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
    maintainers = with stdenv.lib.maintainers; [ symphorien dominikh ];
  };
}
