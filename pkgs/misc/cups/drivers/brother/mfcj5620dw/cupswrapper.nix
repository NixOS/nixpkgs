{ lib, stdenv, fetchurl, mfcj5620dwlpr, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "mfcj5620dw-cupswrapper";
  version = "3.0.1-1";

  src = fetchurl {
    url =
      "https://download.brother.com/welcome/dlf101201/brother_mfcj5620dw_GPL_source_${version}.tar.gz";
    sha256 = "sha256-CnmBpzW/eeeXWCq8CMaErQb8m4RDjLuV6vjzjumr8/8=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ mfcj5620dwlpr ];

  patchPhase = ''
    WRAPPER=cupswrapper/cupswrappermfcj5620dw

    substituteInPlace $WRAPPER \
    --replace /opt "${mfcj5620dwlpr}/opt" \
    --replace /usr "${mfcj5620dwlpr}/usr" \
    --replace /etc "$out/etc"

    substituteInPlace $WRAPPER \
    --replace "cp " "cp -p "
  '';

  buildPhase = ''
    cd brcupsconfig
    make all
    cd ..
  '';

  installPhase = ''
    TARGETFOLDER=$out/opt/brother/Printers/mfcj5620dw/cupswrapper/
    PPDFOLDER=$out/share/cups/model/
    FILTERFOLDER=$out/lib/cups/filter/

    mkdir -p $TARGETFOLDER
    mkdir -p $PPDFOLDER
    mkdir -p $FILTERFOLDER

    cp brcupsconfig/brcupsconfig $TARGETFOLDER
    cp cupswrapper/cupswrappermfcj5620dw $TARGETFOLDER
    cp ppd/brother_mfcj5620dw_printer_en.ppd $PPDFOLDER

    ln -s ${mfcj5620dwlpr}/lib/cups/filter/brother_lpdwrapper_mfcj5620dw $FILTERFOLDER/
  '';

  cleanPhase = ''
    cd brcupsconfig
    make clean
  '';

  meta = {
    homepage = "http://www.brother.com/";
    description = "Brother MFC-J5620DW CUPS wrapper driver";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    downloadPage =
      "http://support.brother.com/g/b/downloadlist.aspx?c=us&lang=en&prod=mfcj5620dw_us_eu_as&os=128";
    maintainers = [ lib.maintainers.leifhelm ];
  };
}
