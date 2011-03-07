x@{builderDefsPackage
  , foomatic_filters, bc, unzip, ghostscript, udev, vim
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="foo2zjs";
    version="20110210";
    name="${baseName}-${version}";
    url="http://www.loegria.net/mirrors/foo2zjs/${name}.tar.gz";
    hash="0vss8gdbbgxr694xw48rys2qflbnb4sp4gdb1v6z4m9ab97hs5yk";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  phaseNames = ["doPatch" "fixHardcodedPaths" "doMakeDirs" "doMakeInstall" "deployGetWeb"];

  patches = [ ./no-hardcode-fw.diff ];

  makeFlags = [
      ''PREFIX=$out''
      ''UDEVBIN=$out/bin''
      ''UDEVDIR=$out/etc/udev/rules.d''
      ''UDEVD=${udev}/sbin/udevd''
      ''LIBUDEVDIR=$out/lib/udev/rules.d''
      ''USBDIR=$out/etc/hotplug/usb''
      ''FOODB=$out/share/foomatic/db/source''
      ''MODEL=$out/share/cups/model''
  ];

  installFlags = [ "install-hotplug" ];

  fixHardcodedPaths = a.fullDepEntry ''
    touch all-test
    sed -e "/BASENAME=/iPATH=$out/bin:$PATH" -i *-wrapper *-wrapper.in
    sed -e '/install-usermap/d' -i Makefile
    sed -e "s@/etc/hotplug/usb@$out&@" -i *rules*
    sed -e "/PRINTERID=/s@=.*@=$out/bin/usb_printerid@" -i hplj1000
  '' ["doPatch" "minInit"];

  doMakeDirs = a.fullDepEntry ''
    mkdir -pv $out/{etc/udev/rules.d,lib/udev/rules.d,etc/hotplug/usb}
    mkdir -pv $out/share/foomatic/db/source/{opt,printer,driver}
    mkdir -pv $out/share/cups/model
  '' ["minInit"];

  deployGetWeb = a.fullDepEntry ''
    ensureDir "$out/bin"
    ensureDir "$out/share"
    cp ./getweb "$out/bin"
    cp ./arm2hpdl "$out/bin"
    cp -r PPD "$out/share/foo2zjs-ppd"
  '' ["minInit" "defEnsureDir"];
      
  meta = {
    description = "ZjStream printer drivers";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.lib.licenses.gpl2Plus;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://packages.debian.org/sid/foo2zjs";
    };
  };
}) x
