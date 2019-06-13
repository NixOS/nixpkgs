{ stdenv, lib, makeWrapper, p7zip
, gawk, utillinux, xorg, glib, dbus-glib, zlib
, kernel ? null, libsOnly ? false
, undmg, fetchurl
}:

assert (!libsOnly) -> kernel != null;
# Disable for kernels 4.15 and above due to compatibility issues
assert kernel != null -> stdenv.lib.versionOlder kernel.version "4.15";

let xorgFullVer = (builtins.parseDrvName xorg.xorgserver.name).version;
    xorgVer = lib.concatStringsSep "." (lib.take 2 (lib.splitString "." xorgFullVer));
    x64 = if stdenv.hostPlatform.system == "x86_64-linux" then true
          else if stdenv.hostPlatform.system == "i686-linux" then false
          else throw "Parallels Tools for Linux only support {x86-64,i686}-linux targets";
in
stdenv.mkDerivation rec {
  version = "${prl_major}.2.1-41615";
  prl_major = "12";
  name = "prl-tools-${version}";

  # We download the full distribution to extract prl-tools-lin.iso from
  # => ${dmg}/Parallels\ Desktop.app/Contents/Resources/Tools/prl-tools-lin.iso
  src = fetchurl {
    url =  "https://download.parallels.com/desktop/v${prl_major}/${version}/ParallelsDesktop-${version}.dmg";
    sha256 = "1jwzwif69qlhmfky9kigjaxpxfj0lyrl1iyrpqy4iwqvajdgbbym";
  };

  hardeningDisable = [ "pic" "format" ];

  # also maybe python2 to generate xorg.conf
  nativeBuildInputs = [ p7zip undmg ] ++ lib.optionals (!libsOnly) [ makeWrapper ] ++ kernel.moduleBuildDependencies;

  inherit libsOnly;

  unpackPhase = ''
    undmg < "${src}"

    export sourceRoot=prl-tools-build
    7z x "Parallels Desktop.app/Contents/Resources/Tools/prl-tools-lin.iso" -o$sourceRoot
    if test -z "$libsOnly"; then
      ( cd $sourceRoot/kmods; tar -xaf prl_mod.tar.gz )
    fi
    ( cd $sourceRoot/tools; tar -xaf prltools${if x64 then ".x64" else ""}.tar.gz )
  '';

  kernelVersion = if libsOnly then "" else (builtins.parseDrvName kernel.name).version;
  kernelDir = if libsOnly then "" else "${kernel.dev}/lib/modules/${kernelVersion}";
  scriptPath = lib.concatStringsSep ":" (lib.optionals (!libsOnly) [ "${utillinux}/bin" "${gawk}/bin" ]);

  buildPhase = ''
    if test -z "$libsOnly"; then
      ( # kernel modules
        cd kmods
        make -f Makefile.kmods \
          KSRC=$kernelDir/source \
          HEADERS_CHECK_DIR=$kernelDir/source \
          KERNEL_DIR=$kernelDir/build \
          SRC=$kernelDir/build \
          KVER=$kernelVersion
      )

      # Xorg config (maybe would be useful for other versions)
      #python2 installer/xserver-config.py xorg ${xorgVer} /dev/null parallels.conf
    fi
  '';

  libPath = with xorg;
            stdenv.lib.makeLibraryPath ([ stdenv.cc.cc libXrandr libXext libX11 libXcomposite libXinerama ]
            ++ lib.optionals (!libsOnly) [ libXi glib dbus-glib zlib ]);


  installPhase = ''
    if test -z "$libsOnly"; then
      ( # kernel modules
        cd kmods
        mkdir -p $out/lib/modules/${kernelVersion}/extra
        cp prl_eth/pvmnet/prl_eth.ko $out/lib/modules/${kernelVersion}/extra
        cp prl_tg/Toolgate/Guest/Linux/prl_tg/prl_tg.ko $out/lib/modules/${kernelVersion}/extra
        cp prl_fs/SharedFolders/Guest/Linux/prl_fs/prl_fs.ko $out/lib/modules/${kernelVersion}/extra
        cp prl_fs_freeze/Snapshot/Guest/Linux/prl_freeze/prl_fs_freeze.ko $out/lib/modules/${kernelVersion}/extra
      )
    fi

    ( # tools
      cd tools
      mkdir -p $out/lib

      if test -z "$libsOnly"; then
        # install binaries
        for i in bin/* sbin/prl_nettool sbin/prl_snapshot; do
          install -Dm755 $i $out/$i
        done
        # other binaries
        for i in xorg.7.1/usr/bin/*; do
          cp $i $out/bin
        done

        for i in $out/bin/* $out/sbin/*; do
          patchelf \
            --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
            --set-rpath "$out/lib:$libPath" \
            $i || true
        done

        mkdir -p $out/bin
        install -Dm755 ../installer/prlfsmountd.sh $out/sbin/prlfsmountd
        wrapProgram $out/sbin/prlfsmountd \
          --prefix PATH ':' "$scriptPath"

        for i in lib/*.a; do
          cp $i $out/lib
        done

        for i in xorg.7.1/usr/lib/libprl_wmouse_watcher.*; do
          cp $i $out/lib
        done

        mkdir -p $out/lib/udev/rules.d
        for i in *.rules; do
          sed 's,/bin/bash,${stdenv.shell},g' $i > $out/lib/udev/rules.d/$i
        done

        (
          cd xorg.${xorgVer}
          # Install the X modules.
          (
            cd x-server/modules
            for i in */*; do
              install -Dm755 $i $out/lib/xorg/modules/$i
            done
          )
          (
            cd usr/lib
            libGLXname=$(echo libglx.so*)
            install -Dm755 $libGLXname $out/lib/xorg/modules/extensions/$libGLXname
            ln -s $libGLXname $out/lib/xorg/modules/extensions/libglx.so
            ln -s $libGLXname $out/lib/xorg/modules/extensions/libglx.so.1
          )
        )
      fi

      for i in xorg.7.1/usr/lib/libGL.*; do
        cp $i $out/lib
      done

      cd $out
      find -name \*.so\* -type f -exec \
        patchelf --set-rpath "$out/lib:$libPath" {} \;

      cd lib
      libGLname=$(echo libGL.so*)
      ln -s $libGLname libGL.so
      ln -s $libGLname libGL.so.1
    )
  '';

  dontStrip = true;
  dontPatchELF = true;

  meta = with stdenv.lib; {
    description = "Parallels Tools for Linux guests";
    homepage = https://parallels.com;
    platforms = [ "i686-linux" "x86_64-linux" ];
    license = licenses.unfree;
    # I was making this package blindly and requesting testing from the real user,
    # so I can't even test it by myself and won't provide future updates.
    maintainers = with maintainers; [ abbradar ];
  };
}
