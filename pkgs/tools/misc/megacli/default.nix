{ stdenv, rpmextract, ncurses, patchelf, makeWrapper, requireFile, unzip }:

assert stdenv.system == "x86_64-linux";

stdenv.mkDerivation rec {
  name = "megacli-8.07.07";

  src =
    requireFile {
      name = "8.07.07_MegaCLI.zip";
      url = http://www.lsi.com/downloads/Public/MegaRAID%20Common%20Files/8.07.07_MegaCLI.zip;
      sha256 = "11jzvh25mlygflazd37gi05xv67im4rgq7sbs5nwgw3gxdh4xfjj";
    };

  buildInputs = [rpmextract ncurses unzip makeWrapper];
  libPath =
    stdenv.lib.makeLibraryPath
       [ stdenv.cc.cc stdenv.cc.libc ncurses ];

  buildCommand = ''
    mkdir -p $out/bin
    cd $out
    unzip ${src}
    rpmextract linux/MegaCli-8.07.07-1.noarch.rpm
    ${patchelf}/bin/patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath ${libPath}:$out/opt/lsi/3rdpartylibs/x86_64:$out/opt/lsi/3rdpartylibs:${stdenv.cc.cc.lib}/lib64:${stdenv.cc.cc.lib}/lib opt/MegaRAID/MegaCli/MegaCli64
    wrapProgram $out/opt/MegaRAID/MegaCli/MegaCli64 --set LD_LIBRARY_PATH $out/opt/lsi/3rdpartylibs/x86_64
    ln -s $out/opt/MegaRAID/MegaCli/MegaCli64 $out/bin/MegaCli64
    eval fixupPhase
  '';

  meta = {
    description = "CLI program for LSI MegaRAID cards, which also works with some Dell PERC RAID cards";
    license = stdenv.lib.licenses.unfree;
  };
}
