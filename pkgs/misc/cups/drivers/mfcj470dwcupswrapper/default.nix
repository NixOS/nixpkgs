{ lib, stdenv, fetchurl, mfcj470dwlpr, makeWrapper}:

stdenv.mkDerivation rec {
  pname = "mfcj470dw-cupswrapper";
  version = "3.0.0-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf006866/mfcj470dw_cupswrapper_GPL_source_${version}.tar.gz";
    sha256 = "b88f9b592723a00c024129560367f40a560ca3cba06fd99512ab368dd6855853";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ mfcj470dwlpr ];

  patchPhase = ''
    WRAPPER=cupswrapper/cupswrappermfcj470dw

    substituteInPlace $WRAPPER \
    --replace /opt "${mfcj470dwlpr}/opt" \
    --replace /usr "${mfcj470dwlpr}/usr" \
    --replace /etc "$out/etc"

    substituteInPlace $WRAPPER \
    --replace "cp " "cp -p "
    '';

  buildPhase = ''
    cd brcupsconfpt1
    make all
    cd ..
    '';

  installPhase = ''
    TARGETFOLDER=$out/opt/brother/Printers/mfcj470dw/cupswrapper/
    PPDFOLDER=$out/share/cups/model/
    FILTERFOLDER=$out/lib/cups/filter/

    mkdir -p $TARGETFOLDER
    mkdir -p $PPDFOLDER
    mkdir -p $FILTERFOLDER

    cp brcupsconfpt1/brcupsconfpt1 $TARGETFOLDER
    cp cupswrapper/cupswrappermfcj470dw $TARGETFOLDER
    cp PPD/brother_mfcj470dw_printer_en.ppd $PPDFOLDER

    ln -s ${mfcj470dwlpr}/lib/cups/filter/brother_lpdwrapper_mfcj470dw $FILTERFOLDER/
    '';

  cleanPhase = ''
    cd brcupsconfpt1
    make clean
    '';

  meta = {
    homepage = "http://www.brother.com/";
    description = "Brother MFC-J470DW CUPS wrapper driver";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    downloadPage = "http://support.brother.com/g/b/downloadlist.aspx?c=us&lang=en&prod=mfcj470dw_us_eu_as&os=128";
    maintainers = [ lib.maintainers.yochai ];
  };
}
