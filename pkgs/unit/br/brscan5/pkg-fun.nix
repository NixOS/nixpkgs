{ stdenv, lib, fetchurl, callPackage, patchelf, makeWrapper, libusb1, avahi-compat, glib, libredirect, nixosTests }:
let
  myPatchElf = file: with lib; ''
    patchelf --set-interpreter \
      ${stdenv.cc.libc}/lib/ld-linux${optionalString stdenv.is64bit "-x86-64"}.so.2 \
      ${file}
  '';
  system = stdenv.hostPlatform.system;

in
stdenv.mkDerivation rec {
  pname = "brscan5";
  version = "1.2.9-0";
  src = {
    "i686-linux" = fetchurl {
      url = "https://download.brother.com/welcome/dlf104034/${pname}-${version}.i386.deb";
      sha256 = "ac23c9a435818955e7882ab06380adf346203ff4e45f384b40e84b8b29642f07";
    };
    "x86_64-linux" = fetchurl {
      url = "https://download.brother.com/welcome/dlf104033/${pname}-${version}.amd64.deb";
      sha256 = "4ec23ff4b457323ae778e871a0f1abcc1848ea105af17850b57f7dcaddcfd96d";
    };
  }."${system}" or (throw "Unsupported system: ${system}");

  unpackPhase = ''
    ar x $src
    tar xfv data.tar.xz
  '';

  nativeBuildInputs = [ makeWrapper patchelf ];
  buildInputs = [ libusb1 avahi-compat stdenv.cc.cc glib ];
  dontBuild = true;

  postPatch =
    let
      patchOffsetBytes =
        if system == "x86_64-linux" then 84632
        else if system == "i686-linux" then 77396
        else throw "Unsupported system: ${system}";
    in
    ''
      ${myPatchElf "opt/brother/scanner/brscan5/brsaneconfig5"}
      ${myPatchElf "opt/brother/scanner/brscan5/brscan_cnetconfig"}
      ${myPatchElf "opt/brother/scanner/brscan5/brscan_gnetconfig"}

      for file in opt/brother/scanner/brscan5/*.so.* opt/brother/scanner/brscan5/brscan_[cg]netconfig; do
        if ! test -L $file; then
          patchelf --set-rpath ${lib.makeLibraryPath buildInputs} $file
        fi
      done

      # driver is hardcoded to look in /opt/brother/scanner/brscan5/models for model metadata.
      # patch it to look in /etc/opt/brother/scanner/models instead, so nixos environment.etc can make it available
      printf '/etc/opt/brother/scanner/models\x00' | dd of=opt/brother/scanner/brscan5/libsane-brother5.so.1.0.7 bs=1 seek=${toString patchOffsetBytes} conv=notrunc
    '';

  installPhase = with lib; ''
    runHook preInstall
    PATH_TO_BRSCAN5="opt/brother/scanner/brscan5"
    mkdir -p $out/$PATH_TO_BRSCAN5
    cp -rp $PATH_TO_BRSCAN5/* $out/$PATH_TO_BRSCAN5


    pushd $out/$PATH_TO_BRSCAN5
      ln -s libLxBsDeviceAccs.so.1.0.0 libLxBsDeviceAccs.so.1
      ln -s libLxBsNetDevAccs.so.1.0.0 libLxBsNetDevAccs.so.1
      ln -s libLxBsScanCoreApi.so.3.2.0 libLxBsScanCoreApi.so.3
      ln -s libLxBsUsbDevAccs.so.1.0.0 libLxBsUsbDevAccs.so.1
      ln -s libsane-brother5.so.1.0.7 libsane-brother5.so.1
    popd

    mkdir -p $out/lib/sane
    for file in $out/$PATH_TO_BRSCAN5/*.so.* ; do
      ln -s $file $out/lib/sane/
    done

    makeWrapper \
      "$out/$PATH_TO_BRSCAN5/brsaneconfig5" \
      "$out/bin/brsaneconfig5" \
      --suffix-each NIX_REDIRECT ":" "/etc/opt/brother/scanner/brscan5=$out/opt/brother/scanner/brscan5 /opt/brother/scanner/brscan5=$out/opt/brother/scanner/brscan5" \
      --set LD_PRELOAD ${libredirect}/lib/libredirect.so

    mkdir -p $out/etc/sane.d/dll.d
    echo "brother5" > $out/etc/sane.d/dll.d/brother5.conf

    mkdir -p $out/etc/udev/rules.d
    cp -p $PATH_TO_BRSCAN5/udev-rules/NN-brother-mfp-brscan5-1.0.2-2.rules \
      $out/etc/udev/rules.d/49-brother-mfp-brscan5-1.0.2-2.rules

    ETCDIR=$out/etc/opt/brother/scanner/brscan5
    mkdir -p $ETCDIR
    cp -rp $PATH_TO_BRSCAN5/{models,brscan5.ini,brsanenetdevice.cfg} $ETCDIR/

    runHook postInstall
  '';

  dontPatchELF = true;

  passthru.tests = { inherit (nixosTests) brscan5; };

  meta = {
    description = "Brother brscan5 sane backend driver";
    homepage = "https://www.brother.com";
    platforms = [ "i686-linux" "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ mattchrist ];
  };
}
