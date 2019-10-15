{ stdenv, rpmextract, ncurses5, patchelf, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "megacli";
  version = "8.07.14";

  src = fetchurl {
    url = "https://docs.broadcom.com/docs-and-downloads/raid-controllers/raid-controllers-common-files/${builtins.replaceStrings ["."] ["-"] version}_MegaCLI.zip";
    sha256 = "1sdn58fbmd3fj4nzbajq3gcyw71ilgdh45r5p4sa6xmb7np55cfr";
  };

  buildInputs = [rpmextract ncurses5 unzip];
  libPath =
    stdenv.lib.makeLibraryPath
       [ stdenv.cc.cc stdenv.cc.libc ncurses5 ];

  buildCommand = ''
    unzip ${src}
    rpmextract Linux/MegaCli-${version}-1.noarch.rpm

    mkdir -p $out/{bin,share/MegaRAID/MegaCli}
    cp -r opt $out
    cp ${version}_MegaCLI.txt $out/share/MegaRAID/MegaCli

    ${patchelf}/bin/patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath}:${stdenv.cc.cc.lib}/lib64:${stdenv.cc.cc.lib}/lib \
      $out/opt/MegaRAID/MegaCli/MegaCli64

    ln -s $out/opt/MegaRAID/MegaCli/MegaCli64 $out/bin/MegaCli64
    eval fixupPhase
  '';

  meta = {
    description = "CLI program for LSI MegaRAID cards, which also works with some Dell PERC RAID cards";
    license = stdenv.lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
