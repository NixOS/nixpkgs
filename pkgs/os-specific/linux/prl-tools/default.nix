{ stdenv
, lib
, makeWrapper
, p7zip
, gawk
, util-linux
, xorg
, glib
, dbus-glib
, zlib
, bbe
, bash
, timetrap
, netcat
, cups
, kernel ? null
, libsOnly ? false
, fetchurl
, undmg
, perl
, autoPatchelfHook
}:

assert (!libsOnly) -> kernel != null;

stdenv.mkDerivation rec {
  version = "18.1.1-53328";
  pname = "prl-tools";

  # We download the full distribution to extract prl-tools-lin.iso from
  # => ${dmg}/Parallels\ Desktop.app/Contents/Resources/Tools/prl-tools-lin.iso
  src = fetchurl {
    url = "https://download.parallels.com/desktop/v${lib.versions.major version}/${version}/ParallelsDesktop-${version}.dmg";
    sha256 = "sha256-Vw9i7Diki+hKODeosxfCY5bL/UOfwgzeCC6+QmWfIZw=";
  };

  hardeningDisable = [ "pic" "format" ];

  nativeBuildInputs = [ p7zip undmg perl bbe autoPatchelfHook ]
    ++ lib.optionals (!libsOnly) [ makeWrapper ] ++ kernel.moduleBuildDependencies;

  buildInputs = with xorg; [ libXrandr libXext libX11 libXcomposite libXinerama ]
    ++ lib.optionals (!libsOnly) [ libXi glib dbus-glib zlib ];

  runtimeDependencies = [ glib xorg.libXrandr ];

  inherit libsOnly;

  unpackPhase = ''
    undmg $src
    export sourceRoot=prl-tools-build
    7z x "Parallels Desktop.app/Contents/Resources/Tools/prl-tools-lin${lib.optionalString stdenv.isAarch64 "-arm"}.iso" -o$sourceRoot
    if test -z "$libsOnly"; then
      ( cd $sourceRoot/kmods; tar -xaf prl_mod.tar.gz )
    fi
  '';

  kernelVersion = lib.optionalString (!libsOnly) kernel.modDirVersion;
  kernelDir = lib.optionalString (!libsOnly) "${kernel.dev}/lib/modules/${kernelVersion}";

  libPath = lib.concatStringsSep ":" [ "${glib.out}/lib" "${xorg.libXrandr}/lib" ];

  scriptPath = lib.concatStringsSep ":" (lib.optionals (!libsOnly) [
    "${util-linux}/bin"
    "${gawk}/bin"
    "${bash}/bin"
    "${timetrap}/bin"
    "${netcat}/bin"
    "${cups}/sbin"
  ]);

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
        cp prl_tg/Toolgate/Guest/Linux/prl_tg/prl_tg.ko $out/lib/modules/${kernelVersion}/extra
        ${lib.optionalString stdenv.isAarch64
        "cp prl_notifier/Installation/lnx/prl_notifier/prl_notifier.ko $out/lib/modules/${kernelVersion}/extra"}
      )
    fi

    ( # tools
      cd tools/tools${if stdenv.isAarch64 then "-arm64" else if stdenv.isx86_64 then "64" else "32"}
      mkdir -p $out/lib

      if test -z "$libsOnly"; then
        # prltoolsd contains hardcoded /bin/bash path
        # we're lucky because it uses only -c command
        # => replace to /bin/sh
        bbe -e "s:/bin/bash:/bin/sh\x00\x00:" -o bin/prltoolsd.tmp bin/prltoolsd
        rm -f bin/prltoolsd
        mv bin/prltoolsd.tmp bin/prltoolsd

        # install binaries
        for i in bin/* sbin/prl_nettool sbin/prl_snapshot; do
          # also patch binaries to replace /usr/bin/XXX to XXX
          # here a two possible cases:
          # 1. it is uses as null terminated string and should be truncated by null;
          # 2. it is uses inside shell script and should be truncated by space.
          for p in bin/* sbin/prl_nettool sbin/prl_snapshot sbin/prlfsmountd; do
            p=$(basename $p)
            bbe -e "s:/usr/bin/$p\x00:./$p\x00\x00\x00\x00\x00\x00\x00\x00:" -o $i.tmp $i
            bbe -e "s:/usr/sbin/$p\x00:./$p\x00\x00\x00\x00\x00\x00\x00\x00 :" -o $i $i.tmp
            bbe -e "s:/usr/bin/$p:$p         :" -o $i.tmp $i
            bbe -e "s:/usr/sbin/$p:$p          :" -o $i $i.tmp
          done

          install -Dm755 $i $out/$i
        done

        install -Dm755 ../../tools/prlfsmountd.sh $out/sbin/prlfsmountd
        for f in $out/bin/* $out/sbin/*; do
          wrapProgram $f \
            --prefix LD_LIBRARY_PATH ':' "$libPath" \
            --prefix PATH ':' "$scriptPath"
        done

        for i in lib/libPrl*.0.0; do
          cp $i $out/lib
          ln -s $out/$i $out/''${i%.0.0}
        done

        mkdir -p $out/share/man/man8
        install -Dm644 ../mount.prl_fs.8 $out/share/man/man8

        substituteInPlace ../99prltoolsd-hibernate \
          --replace "/bin/bash" "${bash}/bin/bash"

        mkdir -p $out/etc/pm/sleep.d
        install -Dm644 ../99prltoolsd-hibernate $out/etc/pm/sleep.d
      fi
    )
  '';

  meta = with lib; {
    description = "Parallels Tools for Linux guests";
    homepage = "https://parallels.com";
    platforms = platforms.linux;
    license = licenses.unfree;
    maintainers = with maintainers; [ catap wegank ];
  };
}
