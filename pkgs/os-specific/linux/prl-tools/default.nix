{ stdenv, lib, makeWrapper, p7zip
, gawk, util-linux, xorg, glib, dbus-glib, zlib
, kernel ? null, libsOnly ? false
, undmg, fetchurl, perl, autoPatchelfHook
}:

assert (!libsOnly) -> kernel != null;

let xorgFullVer = lib.getVersion xorg.xorgserver;
    xorgVer = lib.versions.majorMinor xorgFullVer;
in
stdenv.mkDerivation rec {
  version = "17.1.4-51567";
  pname = "prl-tools";

  # We download the full distribution to extract prl-tools-lin.iso from
  # => ${dmg}/Parallels\ Desktop.app/Contents/Resources/Tools/prl-tools-lin.iso
  src = fetchurl {
    url = "https://download.parallels.com/desktop/v${lib.versions.major version}/${version}/ParallelsDesktop-${version}.dmg";
    sha256 = "sha256-gjLxQOTFuVghv1Bj+zfbNW97q1IN2rurSnPQi13gzRA=";
  };

  hardeningDisable = [ "pic" "format" ];

  nativeBuildInputs = [ p7zip undmg perl autoPatchelfHook ] ++ lib.optionals (!libsOnly) [ makeWrapper ] ++ kernel.moduleBuildDependencies;

  buildInputs = with xorg; [ libXrandr libXext libX11 libXcomposite libXinerama ] ++ lib.optionals (!libsOnly) [ libXi glib dbus-glib zlib ];

  runtimeDependencies = [ glib xorg.libXrandr ];

  inherit libsOnly;

  unpackPhase = ''
    undmg "${src}"

    export sourceRoot=prl-tools-build
    7z x "Parallels Desktop.app/Contents/Resources/Tools/prl-tools-lin${lib.optionalString stdenv.isAarch64 "-arm"}.iso" -o$sourceRoot
    if test -z "$libsOnly"; then
      ( cd $sourceRoot/kmods; tar -xaf prl_mod.tar.gz )
    fi
  '';

  patches = lib.optionals (lib.versionAtLeast kernel.version "5.18") [ ./prl-tools.patch ];

  kernelVersion = lib.optionalString (!libsOnly) kernel.modDirVersion;
  kernelDir = lib.optionalString (!libsOnly) "${kernel.dev}/lib/modules/${kernelVersion}";
  scriptPath = lib.concatStringsSep ":" (lib.optionals (!libsOnly) [ "${util-linux}/bin" "${gawk}/bin" ]);

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
    fi
  '';

  installPhase = ''
    if test -z "$libsOnly"; then
      ( # kernel modules
        cd kmods
        mkdir -p $out/lib/modules/${kernelVersion}/extra
        cp prl_eth/pvmnet/prl_eth.ko $out/lib/modules/${kernelVersion}/extra
        cp prl_tg/Toolgate/Guest/Linux/prl_tg/prl_tg.ko $out/lib/modules/${kernelVersion}/extra
        cp prl_fs/SharedFolders/Guest/Linux/prl_fs/prl_fs.ko $out/lib/modules/${kernelVersion}/extra
        cp prl_fs_freeze/Snapshot/Guest/Linux/prl_freeze/prl_fs_freeze.ko $out/lib/modules/${kernelVersion}/extra
        ${lib.optionalString stdenv.isAarch64
          "cp prl_notifier/Installation/lnx/prl_notifier/prl_notifier.ko $out/lib/modules/${kernelVersion}/extra"
        }
      )
    fi

    ( # tools
      cd tools/tools${if stdenv.isAarch64 then "-arm64" else if stdenv.isx86_64 then "64" else "32"}
      mkdir -p $out/lib

      if test -z "$libsOnly"; then
        # install binaries
        for i in bin/* sbin/prl_nettool sbin/prl_snapshot; do
          install -Dm755 $i $out/$i
        done

        mkdir -p $out/bin
        install -Dm755 ../../tools/prlfsmountd.sh $out/sbin/prlfsmountd
        wrapProgram $out/sbin/prlfsmountd \
          --prefix PATH ':' "$scriptPath"

        for i in lib/lib*.0.0; do
          cp $i $out/lib
          ln -s $out/$i $out/''${i%.0.0}
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

        cp x-server/modules/drivers/prlvideo_drv.so $out/lib/xorg/modules/

        mkdir -p $out/share/man/man8
        install -Dm644 ../mount.prl_fs.8 $out/share/man/man8

        mkdir -p $out/etc/pm/sleep.d
        install -Dm644 ../99prltoolsd-hibernate $out/etc/pm/sleep.d
      fi
    )
  '';

  meta = with lib; {
    description = "Parallels Tools for Linux guests";
    homepage = "https://parallels.com";
    platforms = [ "aarch64-linux" "i686-linux" "x86_64-linux" ];
    license = licenses.unfree;
    maintainers = with maintainers; [ abbradar ];
  };
}
