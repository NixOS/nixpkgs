{ stdenvNoCC, buildPackages, MacOSX-SDK }:

stdenvNoCC.mkDerivation {
  pname = "libSystem";
  version = MacOSX-SDK.version;

  dontBuild = true;
  dontUnpack = true;

  nativeBuildInputs = [ buildPackages.darwin.rewrite-tbd ];

  includeDirs = [
    "CommonCrypto" "_types" "architecture" "arpa" "atm" "bank" "bsd" "bsm"
    "corecrypto" "corpses" "default_pager" "device" "dispatch" "hfs" "i386"
    "iokit" "kern" "libkern" "mach" "mach-o" "mach_debug" "machine" "malloc"
    "miscfs" "net" "netinet" "netinet6" "netkey" "nfs" "os" "osfmk" "pexpert"
    "platform" "protocols" "pthread" "rpc" "rpcsvc" "secure" "security"
    "servers" "sys" "uuid" "vfs" "voucher" "xlocale"
  ] ++ [
    "arm" "xpc" "arm64"
  ];

  csu = [
    "bundle1.o" "crt0.o" "crt1.10.5.o" "crt1.10.6.o" "crt1.o" "dylib1.10.5.o"
    "dylib1.o" "gcrt1.o" "lazydylib1.o"
  ];

  installPhase = ''
    mkdir -p $out/{include,lib/swift}

    for dir in $includeDirs; do
      from=${MacOSX-SDK}/usr/include/$dir
      if [ -e "$from" ]; then
        cp -dr $from $out/include
      else
        echo "Header directory '$from' doesn't exist: skipping"
      fi
    done

    cp -d \
      ${MacOSX-SDK}/usr/include/*.h \
      ${MacOSX-SDK}/usr/include/*.modulemap \
      $out/include

    rm $out/include/tk*.h $out/include/tcl*.h

    cp -dr \
      ${MacOSX-SDK}/usr/lib/libSystem.* \
      ${MacOSX-SDK}/usr/lib/system \
      $out/lib

    # Extra libraries
    for name in c dbm dl info m mx poll proc pthread rpcsvc util gcc_s.1 resolv; do
      cp -d \
        ${MacOSX-SDK}/usr/lib/lib$name.tbd \
        ${MacOSX-SDK}/usr/lib/lib$name.*.tbd \
        $out/lib
    done

    for name in os Dispatch; do
      cp -dr \
        ${MacOSX-SDK}/usr/lib/swift/$name.swiftmodule \
        ${MacOSX-SDK}/usr/lib/swift/libswift$name.tbd \
        $out/lib/swift
    done

    for f in $csu; do
      from=${MacOSX-SDK}/usr/lib/$f
      if [ -e "$from" ]; then
        cp -d $from $out/lib
      else
        echo "Csu file '$from' doesn't exist: skipping"
      fi
    done

    chmod u+w -R $out/lib
    find $out -name '*.tbd' -type f | while read tbd; do
      rewrite-tbd \
        -c /usr/lib/libsystem.dylib:$out/lib/libsystem.dylib \
        -p /usr/lib/system/:$out/lib/system/ \
        -p /usr/lib/swift/:$out/lib/swift/ \
        -r ${builtins.storeDir} \
        "$tbd"
    done
  '';
}

