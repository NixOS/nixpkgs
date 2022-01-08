{ stdenv, lib, makeWrapper, p7zip
, gawk, util-linux, xorg, glib, dbus-glib, zlib
, kernel ? null, libsOnly ? false
, fetchurl, undmg, perl, autoPatchelfHook
}:

assert (!libsOnly) -> kernel != null;

let
  aarch64 = stdenv.hostPlatform.system == "aarch64-linux";
  x86_64 = stdenv.hostPlatform.system == "x86_64-linux";
  i686 = stdenv.hostPlatform.system == "i686-linux";
  _ = if (aarch64 || x86_64 || i686) then true
      else throw "Parallels Tools for Linux only supports {aarch64,x86_64,i686}-linux targets";
in
stdenv.mkDerivation rec {
  version = "${prl_major}.1.1-51537";
  prl_major = "17";
  pname = "prl-tools";

  # We download the full distribution to extract prl-tools-lin.iso from
  # => ${dmg}/Parallels\ Desktop.app/Contents/Resources/Tools/prl-tools-lin.iso
  src = fetchurl {
    url =  "https://download.parallels.com/desktop/v${prl_major}/${version}/ParallelsDesktop-${version}.dmg";
    sha256 = "1ab5jwbg3jgvfwx8kwxwhhrsdp9wz4g9q7fg4z0hhd8v9pgy4yxx";
  };

  hardeningDisable = [ "pic" "format" ];

  nativeBuildInputs = [ p7zip undmg perl autoPatchelfHook ]
    ++ lib.optionals (!libsOnly) [ makeWrapper ] ++ kernel.moduleBuildDependencies;

  buildInputs = with xorg; [ stdenv.cc.cc libXrandr libXext libX11 libXcomposite libXinerama ]
    ++ lib.optionals (!libsOnly) [ libXi glib dbus-glib zlib ];

  runtimeDependencies = [ glib xorg.libXrandr ];

  inherit libsOnly;

  unpackPhase = ''
    undmg "${src}"

    export sourceRoot=prl-tools-build
    7z x "Parallels Desktop.app/Contents/Resources/Tools/prl-tools-lin${if aarch64 then "-arm" else ""}.iso" -o$sourceRoot
    if test -z "$libsOnly"; then
      ( cd $sourceRoot/kmods; tar -xaf prl_mod.tar.gz )
    fi
    # TODO
  '';
    #( cd $sourceRoot/tools; tar -xaf prltools${if x64 then ".x64" else ""}.tar.gz )

  kernelVersion = if libsOnly then "" else lib.getVersion kernel.name;
  kernelDir = if libsOnly then "" else "${kernel.dev}/lib/modules/${kernelVersion}";
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
        cp prl_fs/SharedFolders/Guest/Linux/prl_fs/prl_fs.ko $out/lib/modules/${kernelVersion}/extra
        cp prl_fs_freeze/Snapshot/Guest/Linux/prl_freeze/prl_fs_freeze.ko $out/lib/modules/${kernelVersion}/extra
        ${if aarch64 then "cp prl_notifier/Installation/lnx/prl_notifier/prl_notifier.ko $out/lib/modules/${kernelVersion}/extra" else ""}
        cp prl_tg/Toolgate/Guest/Linux/prl_tg/prl_tg.ko $out/lib/modules/${kernelVersion}/extra
      )
    fi

    ( # tools
      cd tools/tools${if aarch64 then "-arm64" else if x86_64 then "64" else "32"}
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

        for i in lib/*.0.0; do
          cp $i $out/lib
        done

        mkdir -p $out/share/man/man8
        install -Dm644 ../mount.prl_fs.8 $out/share/man/man8

        mkdir -p $out/etc/pm/sleep.d
        install -Dm644 ../99prltoolsd-hibernate $out/etc/pm/sleep.d
      fi

      cd $out/lib
      ln -s libPrlWl.so.1.0.0 libPrlWl.so.1
      ${if aarch64 then "" else "
      ln -s libGL.so.1.0.0 libGL.so
      ln -s libGL.so.1.0.0 libGL.so.1
      ln -s libPrlDRI.so.1.0.0 libPrlDRI.so.1
      ln -s libEGL.so.1.0.0 libEGL.so.1
      ln -s libgbm.so.1.0.0 libgbm.so.1
      "}
    )
  '';

  meta = with lib; {
    description = "Parallels Tools for Linux guests";
    homepage = "https://parallels.com";
    platforms = [ "aarch64-linux" "i686-linux" "x86_64-linux" ];
    license = licenses.unfree;
  };
}
