{ stdenv, fetchurl, cups, gcc, rpmextract }:

stdenv.mkDerivation rec {
  pname = "ctzpos-cups";
  version = "1.2.4";

  src = fetchurl {
    url = "https://www.citizen-systems.co.jp/english/support/download/printer/driver/cups/data_cups/${version}.0/ctzpos-cups-${version}-0.src.rpm";
    sha256 = "0lpligmhvvr0j39f5lc8f7y44zjry95d681wm65jw76alavfn1wa";
  };

  nativeBuildInputs = [ rpmextract ];
  buildInputs = [ cups gcc ];

  unpackCmd = "rpmextract $src; tar xf *.tar.bz2";
  sourceRoot = "ctzpos-cups-${version}";

  patchPhase = ''
    for SRC in *.c; do
      sed -i 's/inline /static inline /g' $SRC
    done   
  '';

  buildPhase = ''
    for SRC in *.c; do
      OBJ=`echo $SRC | sed "s/\.c//"`
      gcc -Wall -fPIC -O2 -o $OBJ $SRC -lcupsimage -lcups
    done
  '';

  installPhase = ''
    mkdir -p $out/share/cups/model
    mkdir -p $out/lib/cups/filter

    # install ppds 
    cp -r *.ppd $out/share/cups/model/
    chmod 0644 $out/share/cups/model/*.ppd

    # install binaries
    for SRC in *.c; do
      OBJ=`echo $SRC | sed "s/\.c//"`
      cp $OBJ $out/lib/cups/filter
      chmod 0755 $OBJ
    done
  '';

  preFixup = ''
    for OUT in $out/lib/cups/filter/*; do
      patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
               --set-rpath ${stdenv.lib.getLib cups}/lib:${stdenv.lib.getLib gcc}/lib $OUT;
    done
  '';

  meta = with stdenv.lib; {
    description = "CUPS drivers for CITIZEN POS printers";
    homepage = https://www.citizen-systems.co.jp/english/;
    downloadPage = https://www.citizen-systems.co.jp/english/support/download/printer/driver/cups/index.html;
    license = licenses.unfree;
    maintainers = [ maintainers.noneucat ];
    platforms = platforms.linux;
  };
}
