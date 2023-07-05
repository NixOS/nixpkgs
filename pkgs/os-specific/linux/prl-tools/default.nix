{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, bbe
, makeWrapper
, p7zip
, perl
, undmg
, dbus-glib
, glib
, xorg
, zlib
, kernel
, bash
, cups
, gawk
, netcat
, timetrap
, util-linux
}:

let
  kernelVersion = kernel.modDirVersion;
  kernelDir = "${kernel.dev}/lib/modules/${kernelVersion}";

  libPath = lib.concatStringsSep ":" [ "${glib.out}/lib" "${xorg.libXrandr}/lib" ];
  scriptPath = lib.concatStringsSep ":" [
    "${bash}/bin"
    "${cups}/sbin"
    "${gawk}/bin"
    "${netcat}/bin"
    "${timetrap}/bin"
    "${util-linux}/bin"
  ];
in
stdenv.mkDerivation rec {
  version = "18.3.1-53614";
  pname = "prl-tools";

  # We download the full distribution to extract prl-tools-lin.iso from
  # => ${dmg}/Parallels\ Desktop.app/Contents/Resources/Tools/prl-tools-lin.iso
  src = fetchurl {
    url = "https://download.parallels.com/desktop/v${lib.versions.major version}/${version}/ParallelsDesktop-${version}.dmg";
    hash = "sha256-MZtNxByY2GSoPFeH9mPieCPPNfUgfla+lYgpeD+SgOc=";
  };

  hardeningDisable = [ "pic" "format" ];

  nativeBuildInputs = [
    autoPatchelfHook
    bbe
    makeWrapper
    p7zip
    perl
    undmg
  ] ++ kernel.moduleBuildDependencies;

  buildInputs = [
    dbus-glib
    glib
    xorg.libX11
    xorg.libXcomposite
    xorg.libXext
    xorg.libXrandr
    xorg.libXi
    xorg.libXinerama
    zlib
  ];

  runtimeDependencies = [
    glib
    xorg.libXrandr
  ];

  unpackPhase = ''
    runHook preUnpack

    undmg $src
    export sourceRoot=prl-tools-build
    7z x "Parallels Desktop.app/Contents/Resources/Tools/prl-tools-lin${lib.optionalString stdenv.isAarch64 "-arm"}.iso" -o$sourceRoot
    ( cd $sourceRoot/kmods; tar -xaf prl_mod.tar.gz )

    runHook postUnpack
  '';

  buildPhase = ''
    runHook preBuild

    ( # kernel modules
      cd kmods
      make -f Makefile.kmods \
        KSRC=${kernelDir}/source \
        HEADERS_CHECK_DIR=${kernelDir}/source \
        KERNEL_DIR=${kernelDir}/build \
        SRC=${kernelDir}/build \
        KVER=${kernelVersion}
    )

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ( # kernel modules
      cd kmods
      mkdir -p $out/lib/modules/${kernelVersion}/extra
      cp prl_fs/SharedFolders/Guest/Linux/prl_fs/prl_fs.ko $out/lib/modules/${kernelVersion}/extra
      cp prl_fs_freeze/Snapshot/Guest/Linux/prl_freeze/prl_fs_freeze.ko $out/lib/modules/${kernelVersion}/extra
      cp prl_tg/Toolgate/Guest/Linux/prl_tg/prl_tg.ko $out/lib/modules/${kernelVersion}/extra
      ${lib.optionalString stdenv.isAarch64
      "cp prl_notifier/Installation/lnx/prl_notifier/prl_notifier.ko $out/lib/modules/${kernelVersion}/extra"}
    )

    ( # tools
      cd tools/tools${if stdenv.isAarch64 then "-arm64" else if stdenv.isx86_64 then "64" else "32"}
      mkdir -p $out/lib

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
          --prefix LD_LIBRARY_PATH ':' "${libPath}" \
          --prefix PATH ':' "${scriptPath}"
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
    )

    runHook postInstall
  '';

  meta = with lib; {
    description = "Parallels Tools for Linux guests";
    homepage = "https://parallels.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ catap wegank ];
    platforms = platforms.linux;
  };
}
